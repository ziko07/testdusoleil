class AddBlockedTimezoneFielsToHits < ActiveRecord::Migration
  def self.up
    add_column :hits, :blocked_timezone, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :hits, :blocked_timezone
  end
end
