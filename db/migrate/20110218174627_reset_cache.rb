class ResetCache < ActiveRecord::Migration
  def self.up
    add_column :sysconfigs, :hit_cache_start, :datetime, :null => false, :default => Time.now
  end

  def self.down
    remove_column :sysconfigs, :hit_cache_start
  end
end
