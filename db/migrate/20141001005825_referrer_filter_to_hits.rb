class ReferrerFilterToHits < ActiveRecord::Migration
  def self.up
    add_column :hits, :blocked_referrer, :boolean, :default => false, :null => false
    add_column :stats, :blocked_referrer, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :hits, :blocked_referrer
    remove_column :stats, :blocked_referrer
  end
end
