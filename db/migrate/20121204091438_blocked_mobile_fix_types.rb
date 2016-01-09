class BlockedMobileFixTypes < ActiveRecord::Migration
  def self.up
    change_column :hits, :blocked_mobile, :boolean, :default => false, :null => false
    change_column :stats, :blocked_mobile, :integer, :default => 0, :null => false
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
