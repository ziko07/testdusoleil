class AddAnalyzed < ActiveRecord::Migration
  def self.up
    add_column :hits, :analyzed, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :hits, :analyzed
  end
end
