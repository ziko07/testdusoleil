class AddIpToTrackers < ActiveRecord::Migration
  def self.up
    add_column :trackers, :ip, :string, :null => false
  end

  def self.down
    remove_column :trackers, :ip
  end
end
