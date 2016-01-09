class DefaultNonNullHits < ActiveRecord::Migration
  def self.up
    # execute "update hits set user_agent = '' where user_agent is null"
    # execute "update hits_archive set user_agent = '' where user_agent is null"
    # execute "update hits set referrer = '' where referrer is null"
    # execute "update hits_archive set referrer = '' where referrer is null"
    # change_column :hits, :user_agent, :string, :default => '', :null => false
    # change_column :hits, :referrer, :string, :default => '', :null => false
  end

  def self.down
  end
end
