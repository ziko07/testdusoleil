class HitStatsPopulate < ActiveRecord::Migration
  def self.up
    HitStat.populate_table
  end

  def self.down
  end
end
