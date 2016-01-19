class AddIpTimezoneAndBrowserTimezoneFieldToHits < ActiveRecord::Migration
  def self.up
    add_column :hits, :ip_timezone, :string
    add_column :hits, :browser_timezone, :string
  end

  def self.down
    remove_column :hits, :browser_timezone
    remove_column :hits, :ip_timezone
  end
end
