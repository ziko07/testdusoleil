class AddWifiFilterOptionsToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :wifi_filter_allow, :boolean, :default => false, :null => false
    add_column :campaigns, :wifi_filter_wifi, :boolean, :default => false, :null => false
    add_column :campaigns, :wifi_filter_at_t, :boolean, :default => false, :null => false
    add_column :campaigns, :wifi_filter_sprint, :boolean, :default => false, :null => false
    add_column :campaigns, :wifi_filter_verizon, :boolean, :default => false, :null => false
    add_column :campaigns, :wifi_filter_t_mobile, :boolean, :default => false, :null => false
    add_column :campaigns, :wifi_filter_boost_mobile, :boolean, :default => false, :null => false
    add_column :campaigns, :wifi_filter_metro_pcs, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :campaigns, :wifi_filter_wifi
    remove_column :campaigns, :wifi_filter_metro_pcs
    remove_column :campaigns, :wifi_filter_boost_mobile
    remove_column :campaigns, :wifi_filter_t_mobile
    remove_column :campaigns, :wifi_filter_verizon
    remove_column :campaigns, :wifi_filter_sprint
    remove_column :campaigns, :wifi_filter_at_t
    remove_column :campaigns, :wifi_filter_allow
  end
end
