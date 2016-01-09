class CreateHitCounts < ActiveRecord::Migration
  def self.up
    create_table :hit_counts do |t|
      t.integer     :hits_total,      :null => false
      t.integer     :hits_blocked,    :null => false
      t.references  :campaign,        :null => false
      t.references  :user_agent,      :null => false
      t.boolean     :blocked,         :null => false
      t.datetime    :blocked_at,      :null => false
      t.integer     :blocked_by,      :null => false
      t.timestamps
    end
    add_index( :hit_counts, :campaign_id )
    add_index( :hit_counts, :user_agent_id )
    add_index( :hit_counts, [:campaign_id, :user_agent_id], :unique => true )
  end
  def self.down
    drop_table :hit_counts
  end
end
