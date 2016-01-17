class AddBrowserTimezoneIpTimezoneCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :browser_timezone, :string
    add_column :campaigns, :ip_timezone, :string
  end

  def self.down
    remove_column :campaigns, :browser_timezone
    remove_column :campaigns, :ip_timezone
  end
end
