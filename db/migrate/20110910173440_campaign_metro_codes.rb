class CampaignMetroCodes < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :geocode_metro_code_list, :string, :limit => 1024
    add_column :geocode_metro_codes, :last_used_at, :date
  end

  def self.down
    remove_column :geocode_metro_codes, :last_used_at
    remove_column :campaigns, :geocode_metro_code_list
  end
end
