class AddHitCacheTimeoutToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :hit_cache_timeout, :integer, default: 1, :null => false
    add_column :campaigns, :hit_cache_start, :datetime
    Campaign.find_each do |campaign|
      campaign.hit_cache_timeout = 1
      campaign.save
    end
  end

  def self.down
    remove_column :campaigns, :hit_cache_start
    remove_column :campaigns, :hit_cache_timeout
  end
end
