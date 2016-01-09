class FilteredDomain < ActiveRecord::Migration
  def self.up
    add_column :hits, :blocked_domain, :boolean, :default => false, :null => false
    add_column :stats, :blocked_domain, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :stats, :blocked_domain
    remove_column :hits, :blocked_domain
  end
end
