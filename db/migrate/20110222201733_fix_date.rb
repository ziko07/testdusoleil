class FixDate < ActiveRecord::Migration
  def self.up
    change_column :sysconfigs, :hit_cache_start, :datetime, :null => false, :default => '2011-02-01 00:00:00'
  end

  def self.down
  end
end
