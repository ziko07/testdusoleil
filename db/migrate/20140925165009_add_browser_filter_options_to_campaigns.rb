class AddBrowserFilterOptionsToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :browser_filter_allow, :boolean, :default => false, :null => false
    add_column :campaigns, :browser_filter_firefox, :boolean, :default => false, :null => false
    add_column :campaigns, :browser_filter_safari, :boolean, :default => false, :null => false
    add_column :campaigns, :browser_filter_chrome, :boolean, :default => false, :null => false
    add_column :campaigns, :browser_filter_internet_explorer, :boolean, :default => false, :null => false
    add_column :campaigns, :browser_filter_opera, :boolean, :default => false, :null => false

    add_column :hits, :blocked_browser, :boolean, default: false, :null => false
    add_column :stats, :blocked_browser, :integer, default: 0, :null => false    
  end

  def self.down
    remove_column :campaigns, :browser_filter_allow
    remove_column :campaigns, :browser_filter_opera
    remove_column :campaigns, :browser_filter_internet_explorer
    remove_column :campaigns, :browser_filter_chrome
    remove_column :campaigns, :browser_filter_safari
    remove_column :campaigns, :browser_filter_firefox
    remove_column :hits,      :blocked_browser
    remove_column :stats,     :blocked_browser
  end
end
