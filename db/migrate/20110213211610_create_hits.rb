class CreateHits < ActiveRecord::Migration
  def self.up
    create_table :hits do |t|
      t.string :ip
      t.string :user_agent
      t.string :referrer
      t.string :fullpath
      t.datetime :created_at
      t.boolean :passed, :null => false
      t.references :campaign, :null => false
    end
  end

  def self.down
    drop_table :hits
  end
end
