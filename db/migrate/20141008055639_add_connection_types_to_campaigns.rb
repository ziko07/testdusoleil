class AddConnectionTypesToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :connection_type_filter_allow, :boolean, :default => false, :null => false
    add_column :campaigns, :connection_type_filter_dial_up, :boolean, :default => false, :null => false
    add_column :campaigns, :connection_type_filter_cellular, :boolean, :default => false, :null => false
    add_column :campaigns, :connection_type_filter_cable_dsl, :boolean, :default => false, :null => false
    add_column :campaigns, :connection_type_filter_corporate, :boolean, :default => false, :null => false

    add_column :hits, :blocked_connection_type, :boolean, default: false, :null => false
    add_column :stats, :blocked_connection_type, :integer, default: 0, :null => false    
  end

  def self.down
    remove_column :campaigns, :connection_type_filter_corporate
    remove_column :campaigns, :connection_type_filter_cable_dsl
    remove_column :campaigns, :connection_type_filter_cellular
    remove_column :campaigns, :connection_type_filter_dial_up
    remove_column :campaigns, :connection_type_filter_allow

    remove_column :hits,      :blocked_connection_type
    remove_column :stats,     :blocked_connection_type
  end
end
