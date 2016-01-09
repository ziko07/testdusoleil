class CreateUserAgents < ActiveRecord::Migration
  def self.up
    create_table :user_agents do |t|
      t.string     :user_agent_string,  :null => false,  :default => ""
      t.string     :user_agent_key,     :null => false,  :default => "",   :limit => 32
      t.timestamps
    end
    add_index( :user_agents, :user_agent_key, :unique => true )
    add_index( :user_agents, :user_agent_string )

  end
  def self.down
    drop_table :user_agents
  end
end
