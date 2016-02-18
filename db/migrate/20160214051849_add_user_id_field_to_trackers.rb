class AddUserIdFieldToTrackers < ActiveRecord::Migration
  def self.up
    add_column :trackers, :user_id, :integer
  end

  def self.down
    remove_column :trackers, :user_id
  end
end
