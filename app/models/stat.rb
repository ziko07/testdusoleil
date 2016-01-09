class Stat < ActiveRecord::Base
  cache_it do |c|
    c.index :campaign_id, :run_at
    c.counters :hits, :passed, :analyzed,
      :blocked_ip, :blocked_proxy_ip, :blocked_domain, :blocked_geocode, :blocked_mobile, :blocked_isp_organization
  end

  belongs_to :campaign

  # _pct methods for view
  def passed_pct
    100.0 * passed / analyzed
  end
  
  def rejected_pct
    100 - passed_pct
  end

  def blocked_ip_pct
    100.0 * blocked_ip / analyzed
  end

  def blocked_proxy_ip_pct
    100.0 * blocked_proxy_ip / analyzed
  end
  
  def blocked_domain_pct
    100.0 * blocked_domain / analyzed
  end

  def blocked_mobile_pct
    100.0 * blocked_mobile / analyzed
  end

  def blocked_geocode_pct
    100.0 * blocked_geocode / analyzed
  end

  def blocked_isp_organization_pct
    100.0 * blocked_isp_organization / analyzed
  end

  def blocked_wifi_carrier_pct
    100.0 * blocked_wifi_carrier / analyzed
  end

  def blocked_browser_pct
    100.0 * blocked_browser / analyzed
  end

  def blocked_referrer_pct
    100.0 * blocked_referrer / analyzed
  end
  
  def self.for_date(campaign_id, date, options = {})
    conds = {:run_at => date, :campaign_id => campaign_id}
    cache_it.find(conds, options) || create(conds)
  end

  def self.today(campaign_id, options = {})
    for_date(campaign_id, Date.today, options)
  end

  def self.save_from_cache
    campaigns = Campaign.where(:archived => false).all
    today = Date.today
    (today-1..today).each do |date|
      campaigns.each do |campaign|
        stat = for_date(campaign.id, date)
        stat.save
      end
    end
  end
end
