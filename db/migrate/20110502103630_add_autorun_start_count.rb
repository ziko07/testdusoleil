class AddAutorunStartCount < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :start_count, :integer, :null => false, :default => 30
  end

  def self.down
    remove_column :campaigns, :start_count
  end
end
