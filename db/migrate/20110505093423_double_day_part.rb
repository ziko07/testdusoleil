class DoubleDayPart < ActiveRecord::Migration
  def self.up
    rename_column :campaigns, :start_hour, :start_hour_1
    rename_column :campaigns, :end_hour, :end_hour_1
    add_column :campaigns, :start_hour_2, :integer
    add_column :campaigns, :end_hour_2, :integer
  end

  def self.down
    remove_column :campaigns, :start_hour_2
    remove_column :campaigns, :end_hour_2
    rename_column :campaigns, :start_hour_1, :start_hour
    rename_column :campaigns, :end_hour_1, :end_hour
  end
end
