class CreateIpconnectionTypes < ActiveRecord::Migration
  def self.up
    create_table :ipconnection_types do |t|
      t.string :prefix
      t.integer :start_ip
      t.integer :end_ip
      t.string :start_ip_addr
      t.string :end_ip_addr
      t.string :connection_type

      t.timestamps
    end
  end

  def self.down
    drop_table :ipconnection_types
  end
end
