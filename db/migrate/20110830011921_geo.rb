class Geo < ActiveRecord::Migration
  def self.up
    create_table :geocode_blocks, :force => true do |t|
      t.column :start_ipnum, 'integer unsigned'
      t.column :end_ipnum, 'integer unsigned'
      t.integer :geocode_location_id
    end
    
    add_index :geocode_blocks, :start_ipnum
    add_index :geocode_blocks, :geocode_location_id
    
    create_table :geocode_locations, :force => true do |t|
      t.string :country
      t.string :region
      t.string :city
      t.string :postal_code
      t.string :lat
      t.string :long
      t.integer :geocode_metro_code_id
      t.string :area_code
    end

    create_table :geocode_metro_codes, :force => true do |t|
      t.string :metro_name
    end

    add_index :geocode_metro_codes, :metro_name
  end

  def self.down
    remove_index :geocode_blocks, :start_ipnum
    remove_index :geocode_blocks, :geocode_location_id
    remove_index :geocode_metro_codes, :metro_name
    
    drop_table :geocode_blocks
    drop_table :geocode_locations
    drop_table :geocode_metro_codes
  end
end
