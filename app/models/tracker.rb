require 'enumerable.rb'

class Tracker < ActiveRecord::Base
  has_many :campaigns, :foreign_key => :tracker, :primary_key => :domain
  belongs_to :user

  validates :domain, :presence => true
  validates :ip, :presence => true

  def self.all_domains
    all.collect(&:domain)
  end
  
  def self.domains_with_usage
    num_campaigns = Campaign.select(:tracker).group(:tracker).count
    domain_pairs = all.map {|tracker| [tracker.domain, num_campaigns[tracker.domain] || 0]}
    domain_pairs = domain_pairs.sort_by(&:second)
  end

  def usage_by_status
    campaigns.count_by(&:status)
  end
  
  def usage_by_status_formatted
   usage_by_status.map{|key, count| "#{key}: #{count}"}.join(", ")
  end
  
  def usage_by_creator
    campaigns.count_by(&:creator)
  end
     
  def usage_by_creator_formatted
   usage_by_creator.map{|key, count| "#{key}: #{count}"}.join(", ")
  end
     
  def usage_by_traffic_type
    campaigns.count_by(&:traffic_type)
  end

  def usage_by_traffic_type_formatted
    usage_by_traffic_type.map{|key, count| "#{key}: #{count}"}.join(", ")
  end

  def usage_long
    ["total:#{self.usage_total}", self.usage_by_traffic_type_formatted, self.usage_by_creator_formatted].select(&:present?).join("; ")   
  end
  
  class AllDomains
    def self.include? domain
      Tracker.all_domains.include? domain
    end
  end
end
