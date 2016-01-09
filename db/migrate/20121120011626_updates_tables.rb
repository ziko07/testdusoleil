class UpdatesTables < ActiveRecord::Migration
  def self.up
    execute "create table blockips_updates like blockips"
    execute "create table geocode_locations_updates like geocode_locations"
    execute "create table geocode_blocks_updates like geocode_blocks"
    execute "create table geocode_metro_codes_updates like geocode_metro_codes"
    create_table :geocode_metro_codes_from_csv, :id => false do |t|
      t.string :province_name
      t.string :metro_name
      t.integer :metro_code
      t.string :criteria_id
    end
  end

  def self.down
    drop_table :blockips_updates
    drop_table :geocode_locations_updates
    drop_table :geocode_blocks_updates
    drop_table :geocode_metro_codes_updates
    drop_table :geocode_metro_codes_from_csv
  end
end
