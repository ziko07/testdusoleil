class SystemPassword < ActiveRecord::Migration
  def self.up
    add_column :sysconfigs, :admin_password, :string, :null => false, :default => ""
  end

  def self.down
    remove_column :sysconfigs, :admin_password
  end
end
