class CountryCodes < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :geocode_country_list, :string, :limit => 1000
    add_column :campaigns, :geocode_country_list_allow, :boolean, :null => false, :default => false
    add_column :campaigns, :geocode_metro_code_list_allow, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :campaigns, :geocode_country_list
    remove_column :campaigns, :geocode_country_list_allow
    remove_column :campaigns, :geocode_metro_code_list_allow
  end
end
