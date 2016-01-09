class CreateSysconfigs < ActiveRecord::Migration
  def self.up
    create_table :sysconfigs do |t|
      t.integer :hit_cache_timeout, :null => false, :default => 1
    end
  end

  def self.down
    drop_table :sysconfigs
  end
end
