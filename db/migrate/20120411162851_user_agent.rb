class UserAgent < ActiveRecord::Migration
  def self.up
    add_column :hits, :blocked_user_agent, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :hits, :blocked_user_agent, :boolean
  end
end
