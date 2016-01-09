class CreateCampaigns < ActiveRecord::Migration
  def self.up
    create_table :campaigns do |t|
      t.boolean :active, :null => false, :default => false
      t.boolean :archived, :null => false, :default => false
      t.string :creator, :null => false
      t.string :safe_lp, :null => false
      t.string :real_lp, :null => false
      t.string :tracker, :null => false
      t.string :sha1
      t.string :url
      t.string :description, :size => 1024
      t.string :rekey_from_1
      t.string :rekey_to_1
      t.string :rekey_from_2
      t.string :rekey_to_2
      t.integer :start_hour
      t.integer :end_hour
    end
  end

  def self.down
    drop_table :campaigns
  end
end
