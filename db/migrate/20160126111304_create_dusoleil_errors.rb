class CreateDusoleilErrors < ActiveRecord::Migration
  def self.up
    create_table :dusoleil_errors do |t|
      t.string :name
      t.integer :campaign_id
      t.datetime :date
      t.string :referer

      t.timestamps
    end
  end

  def self.down
    drop_table :dusoleil_errors
  end
end
