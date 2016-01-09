class CreateHitCacheTracks < ActiveRecord::Migration
  def self.up
    create_table :hit_cache_tracks do |t|
      t.belongs_to :hit
      t.integer :campaign_id
      t.string :ip
      t.datetime :hit_cache_start

      t.timestamps
    end
  end

  def self.down
    drop_table :hit_cache_tracks
  end
end
