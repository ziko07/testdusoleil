require 'ipaddr'

class Hit < ActiveRecord::Base
  cache_it do |c|
    c.index :ip, :campaign_id
    c.expires_in { Sysconfig.singleton.hit_cache_timeout.minutes }
  end

  belongs_to :campaign
  has_one :hit_cache_track
  has_one :user_agents, :class_name => "UserAgent", :foreign_key => :user_agent_key, :primary_key => :md5_user_agent

  def md5_user_agent
    self.connection.raw_connection.query('SELECT MD5("' + user_agent + '")').first[0]
  end

  def redis_key(name)
    Digest::SHA512.hexdigest("name-#{ip}")
  end

  def isp_organization_location_info
    gblock    = GeocodeBlock.find_by_ip(ip)
    if gblock.present?
      glocation = gblock.geocode_location
      organization = REDIS.get(redis_key("organization"))
      unless organization.present?
        ipaddr = IPAddr.new(self.ip).to_i
        organization = connection.select_value("select organization from iplocationdb_organization where prefix = ('#{ipaddr}' >> 24) and '#{ipaddr}' between start_ip and end_ip")
        REDIS.set(redis_key("organization"), organization)
        REDIS.expire(redis_key("organization"), 36000)
      end
      country   = connection.select_value("select name from iplocationdb_country where code = '#{glocation.country}'")
      state     = connection.select_value("select name from iplocationdb_region where country_code = '#{glocation.country}' and region_code = '#{glocation.region}'")
      city      = glocation.city
      org       = organization.present? ? organization : ''
      [country, city, state, org]
    else
      []
    end
  end

  def banned?
    result = Blockip.blocked?(self.ip)
    return result
  end

  def referrer_text
    refs = referrer.split("/")
    res = []
    refs.each do |ref|
      if ref.size > 30
        res << ref.scan(/.{1,30}./).join("<br/>")
      else
        res << ref
      end
    end
    res.flatten.join("/")
  end

  def keywords_hash
    # this rips around the URLARGS and splits them up into ARG => VALUE hash
    @h = Hash.new
    self.fullpath.sub(/[\/|?|h|=]+[a-zA-Z0-9\-]+&/,"").split(/&/).map{|arg| arg.match(/([a-zA-Z0-9\_\-]+)\=([a-zA-Z0-9\_\-]+)/); @h[$1] = $2 }
    return @h
  end

  def keywords_formatted
    # this uses the keywords_hash methods to pull the keywords and then formats them for the report
    @formatted_output_array = Array.new
    self.keywords_hash.each{|kw,arg| @formatted_output_array << "<nobr><span class='label'>#{kw}</span> #{arg}" }
    return @formatted_output_array.join("<br />")
  end

  def user_agent_blocked?
    # Brian Note: I started with a railsy way of figuring out of the hit_count is blocked or not,
    # but we want to create/update things as we're looking as well, and the best and most efficient
    # way to do that seemed to be to get hold of the raw mysql client and directly interact with the db
    #
    # below should result in something like 5 total queries (2 just grabbing cached info) that are quick
    # and do a lot at once.
    #
    # if there's another way to do this... I'd love to learn how.

    return false unless user_agent.present?   # if we don't have a user_agent... there's no point in moving forward (and we shouldn't block)

    dbhandle = self.connection.raw_connection # geb raw connection (gets mysql2 client so we can do raw stuff)

    ua = UserAgent.new                        # start with UserAgent instance
    ua_params = Hash.new("")                  # create hash for columns/values that defaults to "" (avoids errors in SQL command)
    ua_params = ua.serializable_hash          # split the model into a hash so we can all of the column names

    ua_params['user_agent_string'] = ( '"' + self.user_agent + '"' )
    ua_params['user_agent_key']    = ( 'MD5("' + self.user_agent + '")' )   # using MYSQL to create MD5 hash
    ua_params['created_at']        = 'now()'
    ua_params['updated_at']        = 'now()'

    # UserAgent SQL
    ua_sql =  'INSERT into user_agents '                         # This will create a new user agent if no match is found (only first time)
    ua_sql += '(' + ua_params.keys.join(",")  + ') '             # -- adds all column names into column array
    ua_sql += 'VALUES (' + ua_params.values.join(",") + ') '     # -- adds related values into value array
    ua_sql += 'ON DUPLICATE KEY UPDATE '                         # if matching record exists (unique user_agent_key)... then
    ua_sql += 'updated_at=' + ua_params['updated_at']            # -- update the updated_at field

    dbhandle.query(ua_sql)                         # run the query
    ua_id = dbhandle.last_id                       # grab the ID of the match (or new record)

    return false unless ( ua_id > 0  )        # if we don't have a ua_id, then something must have gone wrong and there's no point in moving forward (and we shouldn't block)
    return false unless ( campaign_id > 0  )  # if we don't have a campaign_id, there's no point in moving forward (and we shouldn't block)

    hc = HitCount.new                         # start with HitCount instance
    hc_params = Hash.new("")                  # create hash for columns/values that defaults to "" (avoids errors in SQL command)
    hc_params = hc.serializable_hash          # split the model into a hash so we can all of the column names
    hc_params['user_agent_id'] = ua_id        # user_agent.id from earlier insert
    hc_params['campaign_id']   = self.campaign_id
    hc_params['created_at']    = 'now()'
    hc_params['updated_at']    = 'now()'
    hc_params['hits_total']    = 1

    # HitCount SQL
    hc_sql =  'INSERT INTO hit_counts'                                                    # This will create a new hit_counts record if no match is found
    hc_sql += ' (' + hc_params.keys.join(",") + ')'                                       # -- adds all column names into column array
    hc_sql += ' VALUES (' + hc_params.values.map{|v| v.nil? ? '""' : v}.join(",") + ')'   # -- adds related values into value array
    hc_sql += ' ON DUPLICATE KEY UPDATE'                                                  # if matching record exists (unique campaign_id/user_agent_id combo)... then
    hc_sql += ' updated_at=' + hc_params['updated_at'] + ','                              # -- update updated_at field
    hc_sql += ' hits_total=hits_total + 1,'                                               # -- add one to hits_total
    hc_sql += ' hits_blocked=IF(blocked = 1,hits_blocked+1,hits_blocked)'                 # -- add one to hits_blocked (if user_agent_blocked? i.e. blocked=1 )

    dbhandle.query(hc_sql)                         # run query
    hc_id = dbhandle.last_id                       # grab hit_count ID

    # Now... is it blocked?
    blocked = dbhandle.query('select IF(blocked = 1,1,NULL) as blocked from hit_counts where id=' + hc_id.to_s).first[0]

    # special case for facebook bots
    blocked = true if self.user_agent =~ /(facebook|centos)/i
    # special case by request from Owen
    blocked = true if self.user_agent == 'Apache-HttpClient/4.0.3 (java 1.5)'
    # second special case by request from Owen
    blocked = true if self.user_agent == 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.0.50727)'

    return blocked ? true : false
  end

  def mobile_user_agent_allowed?
    # return true if campaign.mobile_filter_allow == false

    mobile = false
    mobile ||= campaign.mobile_filter_mobile && self.user_agent =~ /Mobile/
    mobile ||= campaign.mobile_filter_android && self.user_agent =~ /Android/
    mobile ||= campaign.mobile_filter_ios && self.user_agent =~ /(iPhone|iPad|iPod)/
    return campaign.mobile_filter_allow == !!mobile
  end

  def referrer_domain_allowed?
    # return true if campaign.filter_domain_allow == false
    referrer = false
    referrer ||= campaign.filter_domain_facebook && self.referrer.downcase =~ /facebook/
    referrer ||= campaign.filter_domain_google && self.referrer.downcase =~ /google/
    referrer ||= campaign.filter_domain_msn && self.referrer.downcase =~ /msn/

    if campaign.filter_broad_match
      input_url     = !!(campaign.filter_domain_other =~ /http/) ? campaign.filter_domain_other : "http://"+campaign.filter_domain_other
      input_host    = URI.parse(input_url).host

      host = URI.parse(self.referrer).host
      if host.nil?
        referrer ||= campaign.filter_broad_match && false
      elsif host =~ /#{input_host}/
        referrer ||= campaign.filter_broad_match && true
      else
        referrer ||= campaign.filter_broad_match && false
      end
    end

    if campaign.filter_exact_match
      # input_url = !!(campaign.filter_domain_other =~ /http/) ? campaign.filter_domain_other : "http://"+campaign.filter_domain_other

      # input_host    = URI.parse(input_url).host
      # referer_host   = URI.parse(self.referrer).host
      # referer_path  = URI.parse(self.referrer).path

      # if !!(referer_host =~ /#{input_host}/)==true and referer_path.size < 2
      #   referrer ||= campaign.filter_exact_match && true
      # else
      #   referrer ||= campaign.filter_exact_match && false
      # end

      if self.referrer.downcase =~ /#{campaign.filter_domain_other}/
        str = String.new(self.referrer)
        str.slice!(campaign.filter_domain_other)
        if str.length <= 8 # http:// delete(referrer) /
          referrer ||= campaign.filter_exact_match && true
        else
          referrer ||= campaign.filter_exact_match && false
        end
      else
        referrer ||= campaign.filter_exact_match && false
      end

    end

    return campaign.filter_domain_allow == !!referrer
  end


  def connection_type_allowed?

    if campaign.connection_type_filter_allow | campaign.connection_type_filter_dial_up | campaign.connection_type_filter_cellular | campaign.connection_type_filter_cable_dsl | campaign.connection_type_filter_corporate
      connection_type = REDIS.get(redis_key("connection_type"))
      unless connection_type.present?
        ipaddr = IPAddr.new(self.ip).to_i
        connection_type = connection.select_value("select connection_type from ipconnection_types where prefix = ('#{ipaddr}' >> 24) and '#{ipaddr}' between start_ip and end_ip")
        REDIS.set(redis_key("connection_type"), connection_type)
        REDIS.expire(redis_key("connection_type"), 36000)
      end
      if connection.present?
        connec_type = false
        connec_type ||= campaign.connection_type_filter_dial_up && connection_type.downcase =~ /dialup/
        connec_type ||= campaign.connection_type_filter_cellular && connection_type.downcase =~ /cellular/
        connec_type ||= campaign.connection_type_filter_cable_dsl && connection_type.downcase =~ /cable\/dsl/
        connec_type ||= campaign.connection_type_filter_corporate && connection_type.downcase =~ /corporate/

        return campaign.connection_type_filter_allow == !!connec_type
      else
        return true
      end
    else
      return true
    end
  end

  def carrier_user_agent_allowed?

    if campaign.wifi_filter_at_t | campaign.wifi_filter_sprint | campaign.wifi_filter_verizon | campaign.wifi_filter_t_mobile | campaign.wifi_filter_boost_mobile | campaign.wifi_filter_metro_pcs | campaign.wifi_filter_allow
      organization = REDIS.get(redis_key("organization"))
      unless organization.present?
        ipaddr = IPAddr.new(self.ip).to_i
        organization = connection.select_value("select organization from iplocationdb_organization where prefix = ('#{ipaddr}' >> 24) and '#{ipaddr}' between start_ip and end_ip")
        REDIS.set(redis_key("organization"), organization)
        REDIS.expire(redis_key("organization"), 36000)
      end

      if organization.present?
        wifi = false
        # wifi ||= campaign.wifi_filter_wifi && organization.organization.downcase =~ /wifi/
        wifi ||= campaign.wifi_filter_at_t && organization.downcase =~ /at&t/
        wifi ||= campaign.wifi_filter_sprint && organization.downcase =~ /sprint/
        wifi ||= campaign.wifi_filter_verizon && organization.downcase =~ /verizon/
        wifi ||= campaign.wifi_filter_t_mobile && organization.downcase =~ /t-mobile/
        wifi ||= campaign.wifi_filter_boost_mobile && organization.downcase =~ /boost mobile/
        wifi ||= campaign.wifi_filter_metro_pcs && organization.downcase =~ /metro pcs/

        return campaign.wifi_filter_allow == !!wifi
      else
        return true
      end
    else
      return true
    end
  end

  def browser_user_agent_allowed?

    browser = false
    browser ||= campaign.browser_filter_firefox && self.user_agent =~ /Firefox/
    browser ||= campaign.browser_filter_safari && self.user_agent =~ /Safari/
    browser ||= campaign.browser_filter_chrome && self.user_agent =~ /Chrome/
    browser ||= campaign.browser_filter_internet_explorer && self.user_agent =~ /MSIE/
    browser ||= campaign.browser_filter_opera && self.user_agent =~ /OPR/
    return campaign.browser_filter_allow == !!browser
  end

  def organization_allowed?

    filter = []
    filter = filter + ['Facebook'] if campaign.filter_organization_facebook
    filter = filter + ['Google']   if campaign.filter_organization_google
    filter = filter + ['MSN']      if campaign.filter_organization_msn
    filter = filter + campaign.filter_organization_other.split(/ *, */) if campaign.filter_organization_other

    # pass if nothing to filter for
    return true if filter.blank?

    ipaddr = IPAddr.new(self.ip).to_i
    organization = REDIS.get(redis_key("organization"))
    unless organization.present?
      organization = connection.select_value("select organization from iplocationdb_organization where prefix = ('#{ipaddr}' >> 24) and '#{ipaddr}' between start_ip and end_ip")
      REDIS.set(redis_key("organization"), organization)
      REDIS.expire(redis_key("organization"), 36000)
    end

    if filter.index('Facebook')
      isp = REDIS.get(redis_key("isp"))
      unless isp.present?
        isp = connection.select_value("select isp from iplocationdb_isp where prefix = ('#{ipaddr}' >> 24) and '#{ipaddr}' between start_ip and end_ip")
        REDIS.set(redis_key("isp"), isp)
        REDIS.expire(redis_key("isp"), 36000)
      end

      return false if isp =~ /Joyent/
    end

    return campaign.filter_organization_allow == !!filter.any?{|f|organization.downcase.index(f.downcase)}
  end

  def self.select_lp_from_request(request, campaign)
    stat = Stat.today(campaign.id, :skip_counters => true)
    stat.hits += 1
    stat.save
    # stat.cache_it.increment :hits

    hit_redis_key = Digest::SHA512.hexdigest("hit_#{campaign.id}_#{request.ip}")
    hit_cache_track = REDIS.get(hit_redis_key)
    return :safe_lp if hit_cache_track.present?

    begin
      hit = Hit.new do |hit|
        hit.ip = request.ip
        hit.user_agent = request.user_agent || ''
        hit.referrer = request.referrer || ''
        hit.forwarded_for = request.headers['X-FORWARDED-FOR']
        hit.fullpath = request.fullpath
        hit.campaign_id = campaign.id
        hit.analyzed = false
        hit.passed = false
      end

      # Rails.logger.info "env hash: " + request.env.inspect
      # Rails.logger.info "headers hash: " + request.headers.inspect
      # Rails.logger.info "referrer: " + request.referrer if request.referrer
      # Rails.logger.info "env[referrer]: " + request.env['HTTP_REFERRER'] if request.env['HTTP_REFERRER']
      # Rails.logger.info "domain: " + request.domain if request.domain

      if campaign.status == "off" and campaign.autorun
        if campaign.started?
          campaign.status = "on"
          campaign.autorun = false
          campaign.sent_mail = true
          campaign.save
          CampaignMailer.notification(campaign,0) if campaign.email_notification
        else
          Blockip.create(:ip => hit.ip, :source => 'autorun')
          return :safe_lp
        end
      end
      return :safe_lp if not campaign.status == "on"
      return :safe_lp if not campaign.within_day_part?

      hit.analyzed = true
      stat.analyzed += 1
      stat.save
      # stat.cache_it.increment :analyzed

      hit.passed = ! Blockip.blocked?(hit.ip)
      unless hit.passed
        hit.blocked_ip = true
        stat.blocked_ip += 1
        # stat.cache_it.increment :blocked_ip
        stat.save
        return :safe_lp
      end

      hit.passed &&= ! Blockip.blocked?(hit.forwarded_for)
      unless hit.passed
        hit.blocked_proxy_ip = true
        stat.blocked_proxy_ip += 1
        # stat.cache_it.increment :blocked_proxy_ip
        stat.save
        return :safe_lp
      end

      hit.passed &&= ! hit.user_agent_blocked?
      unless hit.passed
        hit.blocked_user_agent = true
        Blockip.create(:ip => hit.ip, :source => 'useragent')
        # TODO stat.cache_it.increment :blocked_user_agent
        stat.save

        return :safe_lp
      end

      hit.passed &&= hit.organization_allowed?
      unless hit.passed
        hit.blocked_organization = true
        # TODO stat.cache_it.increment :blocked_user_agent
        stat.blocked_isp_organization += 1
        stat.save

        return :safe_lp
      end

      hit.passed &&= hit.mobile_user_agent_allowed?
      unless hit.passed
        hit.blocked_mobile = true
        stat.blocked_mobile += 1
        # stat.cache_it.increment :blocked_mobile
        stat.save

        return :safe_lp
      end

      hit.passed &&= hit.connection_type_allowed?
      unless hit.passed
        hit.blocked_connection_type = true
        stat.blocked_connection_type += 1
        stat.save

        return :safe_lp
      end

      hit.passed &&= hit.carrier_user_agent_allowed?
      unless hit.passed
        hit.blocked_wifi_carrier = true
        stat.blocked_wifi_carrier += 1
        stat.save

        return :safe_lp
      end

      hit.passed &&= hit.browser_user_agent_allowed?
      unless hit.passed
        hit.blocked_browser = true
        stat.blocked_browser += 1
        stat.save
        return :safe_lp
      end

      hit.passed &&= campaign.referer_domain_allowed?(request.referrer)
      unless hit.passed
        hit.blocked_domain = true
        stat.blocked_domain += 1
        # stat.cache_it.increment :blocked_domain
        stat.save
        return :safe_lp
      end

      hit.passed &&= hit.referrer_domain_allowed?
      unless hit.passed
        hit.blocked_referrer = true
        stat.blocked_referrer += 1
        stat.save
        return :safe_lp
      end


      if hit.passed && (campaign.geocode_metro_code_list.present? || campaign.countries.present?)
        block = GeocodeBlock.find_by_ip(hit.ip)
        location = block.geocode_location if block
        if location
          metro_code_id = location.geocode_metro_code_id
          country = location.country
        end

        if metro_code_id != 0 && campaign.geocode_metro_code_list.present?
          hit.geocode_metro_code_id = metro_code_id
          if campaign.geocode_metro_code_list_allow
            hit.passed &&= !! campaign.metro_codes[metro_code_id]
          else
            hit.passed &&= ! campaign.metro_codes[metro_code_id]
          end
        end

        unless  country.present?
          if ENV['RAILS_ENV'] == 'development'
            ip = '103.15.140.69'
            # ip = '125.26.112.3'
          else
            ip = hit.ip
          end
          require 'net/http'
          url = URI.parse("http://freegeoip.net/json/#{ip}")
          req = Net::HTTP::Get.new(url.to_s)
          res = Net::HTTP.start(url.host, url.port) { |http|
            http.request(req)
          }
          response = res.body
          if response.present?
            @response = JSON.parse(response)
          end
          country = @response['country_code']
        end

        if country.present? && campaign.countries.present?
          if campaign.geocode_country_list_allow
            hit.passed &&= !! campaign.countries[country]
          else
            hit.passed &&= ! campaign.countries[country]
          end
        end
        unless hit.passed
          hit.blocked_geocode = true
          stat.blocked_geocode += 1
          # stat.cache_it.increment :blocked_geocode
          stat.save
          return :safe_lp
        end
      end
      if hit.passed && !campaign.match_timezone
        return :safe_lp
      end
      stat.passed += 1
      # stat.cache_it.increment :passed
      stat.save
      return :real_lp
    ensure
      hit.save
      REDIS.set(hit_redis_key, hit.id)
      REDIS.expire(hit_redis_key, Sysconfig.singleton.hit_cache_timeout.minutes.to_i)

      if campaign.hits.count - campaign.mail_hit == 10
        campaign.sent_mail = true
        campaign.save
        CampaignMailer.notification(campaign, 1) if campaign.email_notification
      end
      # HitCacheTrack.find_or_create_by_ip_and_campaign_id(request.ip,campaign.id).update_attributes(hit_id:hit.id, hit_cache_start:Time.now)
    end
  end

  def self.clear_data
    old_data = Hit.where("created_at < DATE('#{Time.now-7.days}')");
    old_data.destroy_all

    old_data = HitCount.where("created_at < DATE('#{Time.now-7.days}')");
    old_data.destroy_all

  end
end
