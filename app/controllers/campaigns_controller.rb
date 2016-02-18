class CampaignsController < ApplicationController
  before_filter :get_campaign,        :except => [:new, :create, :index, :autocomplete, :campaign_clone]
  before_filter :get_system_hit_info, :except => [:new, :create, :autocomplete, :campaign_clone]
  before_filter :get_campaign_info,   :except => [:new, :create, :index, :autocomplete, :campaign_clone]
  attr_accessor :browser_time, :ip_time
  before_filter :authenticate_user!

  # GET /campaigns
  def index
    params[:c]  &= Campaign::CREATORS
    params[:t]  &= Tracker.all_domains
    params[:s]  &= ["on","off"]
    params[:tt] &= Campaign::TRAFFIC_TYPE_VALUES
    if current_user.is_admin
      scope = Campaign.where(:archived => false)
    else
      scope = current_user.campaigns.where(:archived => false)
    end


    if params[:key] == params[:key].to_i.to_s
      scope = scope.where(id:params[:key])
    else
      scope = scope.search(params[:key]) if params[:key].present?
      scope = scope.where(:creator => params[:c]) if params[:c].present?
      scope = scope.where(:tracker => params[:t]) if params[:t].present?
      scope = scope.where(:status => params[:s])  if params[:s].present?
      scope = scope.where(:traffic_type => params[:tt]) if params[:tt].present?
    end
    @campaigns = scope.all
    if params[:sort_option] == nil
      @campaigns.sort!{|a,b| b.hit_counts_total <=> a.hit_counts_total}
    elsif params[:sort_option] == 'sorting_asc'
      @campaigns.sort!{|a,b| a.id <=> b.id}
    else
      @campaigns.sort!{|a,b| b.id <=> a.id}
    end
    # @campaigns.sort!{|a,b| b.hit_counts_total <=> a.hit_counts_total}
    @filter_on =  params[:c].present? || params[:t].present? || params[:s].present? || params[:tt].present?
  end

  # GET /campaigns/1
  def show
    ip = request.remote_ip
    if ENV['RAILS_ENV'] == 'development'
       #ip = '103.15.140.69'
       ip = '213.155.18.3'
    end
    @ip_timezone = Campaign.check_timezone(ip)
    @metro_codes_recent, @metro_codes_not_recent = @campaign.all_metro_codes_partition
    @org_other_data = @campaign.filter_organization_other.present? ? @campaign.filter_organization_other.split(",").map{|o| {id:o, name:o.capitalize}} : {}
    @domain_other_data = @campaign.filter_domain_other.present? ? @campaign.filter_domain_other.split(",").map{|o| {id:o, name:o.capitalize}} : {}
  end

  # GET /campaigns/new
  def new
    @campaign = Campaign.new
    @campaign.safe_lp = "http://"
    @campaign.real_lp = "http://"
    @campaign.rekey_from_1 = "kw"
    @campaign.rekey_to_1 = "kw"
    @metro_codes_recent, @metro_codes_not_recent = @campaign.all_metro_codes_partition
    ip = request.remote_ip
    if ENV['RAILS_ENV'] == 'development'
       # ip = '103.15.140.69'
      ip = '46.165.220.219'
    end
    @ip_timezone = Campaign.check_timezone(ip)
    render "show"
  end
  
  def campaign_clone
    campaign = Campaign.find(params[:id])
    @new_campaign = campaign.clone
    # @new_campaign.safe_lp = "http://test.com"
    # @new_campaign.real_lp = "http://test.com"
    # @new_campaign.rekey_from_1 = "kw"
    # @new_campaign.rekey_to_1 = "kw"
    @new_campaign.sha1 = ''
    @metro_codes_recent, @metro_codes_not_recent = campaign.all_metro_codes_partition
    if @new_campaign.save
      @campaign = @new_campaign
      redirect_to(@campaign, :notice => 'Campaign was successfully cloned.')
    else
      render :action => "show"
    end
  end

  # POST /campaigns
  def create
    @campaign = current_user.campaigns.new(params[:campaign])
    if ((params[:campaign][:ip_timezone].present?) && params[:campaign][:browser_timezone].present? )
      if(params[:campaign][:ip_timezone].downcase == params[:campaign][:browser_timezone].downcase)
        @campaign.match_timezone = true
      end
    end
    if @campaign.save
      redirect_to(@campaign, :notice => 'Campaign was successfully created.')
    else
      render :action => "show"
    end
  end

  # PUT /campaigns/1
  def update
    # in case it wasn't set at all
    if ((params[:campaign][:ip_timezone].present?) && params[:campaign][:browser_timezone].present? )
      if(params[:campaign][:ip_timezone].downcase == params[:campaign][:browser_timezone].downcase)
        @campaign.update_attributes(match_timezone: true)
      else
        @campaign.update_attributes(match_timezone: false)
      end
    end
    services = params[:campaign][:mail_services]
    params[:campaign][:mail_services] = services.present? ? services.join(",") : ""
    
    params[:campaign][:metro_codes] ||= {}    
    if params[:hidden_email_notification_reset] == 'reset'      
      @campaign.update_attributes(mail_hit:@campaign.hits.count, sent_mail:false)
    end
    status = @campaign.update_attributes(params[:campaign])
    if request.GET.present?  # if coming from index view
      redirect_to campaigns_path
    elsif status
      redirect_to(@campaign, :notice => 'Campaign was successfully updated.')
    else
      @metro_codes_recent, @metro_codes_not_recent = @campaign.all_metro_codes_partition
      render :action => "show"
    end
  end

  # DELETE /campaigns/1
  def destroy
    @campaign.update_attribute(:archived, true)
    redirect_to(campaigns_url)
  end

  # ANY /campaigns/1/stats
  def stats
    @days = (params[:days] || "7").to_i
    today = Date.today
    @stats = (today-@days+1..today).map do |date| 
      stat = Stat.for_date(@campaign.id, date)
    end
    @stats.reverse!
  end
  
  # ANY /campaigns/1/hits
  def hits
    scope = Hit.where(:campaign_id => params[:id])
    scope = scope.order('hits.created_at desc, hits.passed desc').limit(100)
    @hits = scope.all
  end

  # ANY /campaigns/1/hit_counts
  def hit_counts
    @hit_counts = HitCount.includes(:user_agent).where(:campaign_id => params[:id]).order("hits_total DESC").limit(100)
  end
  
  # ANY /campaigns/autocomplete?q=china
  def autocomplete
    q = params[:q].present? ? params[:q].downcase : ''
    results = []
    if q.length >= 3
      results = IplocationdbOrganization.where("LOWER(organization) LIKE ?", "%#{q}%").limit(20)
    end    
    render json: results.map{|r| {id:r.organization.downcase, name:r.organization}}
  end

  def referer_autocomplete
    q = params[:q].present? ? params[:q].downcase : ''
    results = []
    if q.length >= 3
      results = Campaign.where("LOWER(filter_domain_other) LIKE ?", "%#{q}%").limit(20)
    end
    render json: results.map{|r| {id:r.filter_domain_other.downcase, name:r.filter_domain_other.capitalize}}
  end

  protected
  
  def get_campaign
    if current_user.is_admin
      @campaign = Campaign.cache_it.find :id => params[:id].to_i
    else
      @campaign = current_user.campaigns.cache_it.find :id => params[:id].to_i
    end
  end
  
  def get_system_hit_info
    @system_hits_first_at = Hit.first.try(:created_at)
  end
  
  def get_campaign_info
    @campaign_hits_first_at = Hit.where(:campaign_id => params[:id]).first.try(:created_at)
    @campaign_hits_last_at = Hit.where(:campaign_id => params[:id]).last.try(:created_at)
    if @campaign_hits_first_at
      @campaign_days_running = ((@campaign_hits_last_at - @campaign_hits_first_at)/60/60/24).round(1).to_s + " Days"
    end
    @campaign_hits_total = @campaign.present? ? @campaign.hit_counts_total : ''
  end

end



