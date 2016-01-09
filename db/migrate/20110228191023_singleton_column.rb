class SingletonColumn < ActiveRecord::Migration
  def self.up
    add_column    :sysconfigs, :singleton, :boolean, :null => false, :default => true
    change_column :sysconfigs, :singleton, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :sysconfigs, :singleton
  end
end
