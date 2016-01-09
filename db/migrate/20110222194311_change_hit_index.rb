class ChangeHitIndex < ActiveRecord::Migration
  def self.up
    remove_index :hits, [:campaign_id, :ip]
    add_index :hits, [:campaign_id, :ip, :created_at]
  end

  def self.down
    remove_index :hits, [:campaign_id, :ip, :created_at]
    add_index :hits, [:campaign_id, :ip]
  end
end
