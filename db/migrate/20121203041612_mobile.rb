class Mobile < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :mobile_filter_allow, :boolean, :default => false
    add_column :campaigns, :mobile_filter_mobile, :boolean, :default => false
    add_column :campaigns, :mobile_filter_android, :boolean, :default => false
    add_column :campaigns, :mobile_filter_ios, :boolean, :default => false
    add_column :hits, :blocked_mobile, :integer, :default => 0
    add_column :hits_archive, :blocked_mobile, :integer, :default => 0
    add_column :stats, :blocked_mobile, :integer, :default => 0
  end

  def self.down
    remove_column :campaigns, :mobile_filter_allow
    remove_column :campaigns, :mobile_filter_mobile
    remove_column :campaigns, :mobile_filter_android
    remove_column :campaigns, :mobile_filter_ios
    remove_column :hits, :blocked_mobile
    remove_column :hits_archive, :blocked_mobile
    remove_column :stats, :blocked_mobile
  end
end
