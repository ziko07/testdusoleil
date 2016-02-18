class AddUserIdToUserAgents < ActiveRecord::Migration
  def self.up
    add_column :user_agents, :user_id, :integer
    remove_index( :user_agents, :user_agent_key)
    add_index( :user_agents, :user_agent_key)
  end


  def self.down
    remove_column :user_agents, :user_id
  end
end
