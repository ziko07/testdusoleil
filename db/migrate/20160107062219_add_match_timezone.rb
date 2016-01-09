class AddMatchTimezone < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :match_timezone, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :campaigns, :match_timezone
  end
end
