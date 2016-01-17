class AddBlockedTimezoneFieldToStats < ActiveRecord::Migration
  def self.up
    add_column :stats, :stat_timezone, :integer, default: 0
  end

  def self.down
    remove_column :stats, :stat_timezone
  end
end
