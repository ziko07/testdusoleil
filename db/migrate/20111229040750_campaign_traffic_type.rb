class CampaignTrafficType < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :traffic_type, :string
  end

  def self.down
    remove_column :campaigns, :traffic_type
  end
end
