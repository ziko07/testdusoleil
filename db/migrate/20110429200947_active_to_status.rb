class ActiveToStatus < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :status, :string, :null => false, :default => "off"
    execute "update campaigns set status = 'on' where active = '1'"
    remove_column :campaigns, :active
  end

  def self.down
    add_column :campaigns, :active, :boolean, :default => false, :null => false
    execute "update campaigns set active = '1' where status = 'on'"
    remove_column :campaigns, :status
  end
end
