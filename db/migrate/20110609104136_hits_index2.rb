class HitsIndex2 < ActiveRecord::Migration
  def self.up
    add_index :hits, [:created_at]
    remove_index :hits, [:ip, :created_at, :passed]
  end

  def self.down
    remove_index :hits, [:created_at]
    add_index :hits, [:ip, :created_at, :passed]
  end
end
