class HitGeocodeMetroCode < ActiveRecord::Migration
  def self.up
    add_column :hits, :geocode_metro_code_id, :integer
    add_column :hits, :blocked_geocode, :boolean, :default => false, :null => false
    add_column :stats, :blocked_geocode, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :hits, :geocode_metro_code_id
    remove_column :hits, :blocked_geocode
    remove_column :stats, :blocked_geocode
  end
end
