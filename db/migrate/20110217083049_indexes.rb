class Indexes < ActiveRecord::Migration
  def self.up
    add_index :campaigns, :sha1, :unique => true
    add_index :campaigns, :archived
    add_index :blockips, :ip
    add_index :hits, [:campaign_id, :ip]
  end

  def self.down
    remove_index :hits, [:campaign_id, :ip]
    remove_index :blockips, :ip
    remove_index :campaigns, :archived
    remove_index :campaigns, :sha1
  end
end
