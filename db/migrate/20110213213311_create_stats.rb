class CreateStats < ActiveRecord::Migration
  def self.up
    create_table :stats do |t|
      t.date :run_at, :null => false
      t.integer :hits, :null => false, :default => 0
      t.integer :analyzed, :null => false, :default => 0
      t.integer :passed, :null => false, :default => 0
      t.references :campaign, :null => false
    end
  end

  def self.down
    drop_table :stats
  end
end
