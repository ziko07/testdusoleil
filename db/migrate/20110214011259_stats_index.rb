class StatsIndex < ActiveRecord::Migration
  def self.up
    add_index :stats, [:campaign_id, :run_at], :unique => true
  end

  def self.down
    remove_index :stats, [:campaign_id, :run_at]
  end
end
