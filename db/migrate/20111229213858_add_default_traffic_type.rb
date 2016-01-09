class AddDefaultTrafficType < ActiveRecord::Migration
  def self.up
    change_column :campaigns, :traffic_type, :string, :default => "other", :null => false
  end

  def self.down
  end
end
