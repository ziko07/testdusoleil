class AddAutorun < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :autorun, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :campaigns, :autorun
  end
end
