class CreateTrackers < ActiveRecord::Migration
  def self.up
    create_table :trackers do |t|
      t.string :domain, :null => false
    end
  end

  def self.down
    drop_table :trackers
  end
end
