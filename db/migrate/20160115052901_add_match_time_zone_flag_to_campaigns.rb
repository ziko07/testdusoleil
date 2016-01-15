class AddMatchTimeZoneFlagToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :match_time_zone_flag, :boolean
  end

  def self.down
    remove_column :campaigns, :match_time_zone_flag
  end
end
