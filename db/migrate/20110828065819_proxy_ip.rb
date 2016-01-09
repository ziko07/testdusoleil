class ProxyIp < ActiveRecord::Migration
  def self.up
    add_column :hits, :forwarded_for, :string
    add_column :hits, :blocked_ip, :boolean, :null => false, :default => false
    add_column :hits, :blocked_proxy_ip, :boolean, :null => false, :default => false
    add_column :stats, :blocked_ip, :integer, :null => false, :default => 0
    add_column :stats, :blocked_proxy_ip, :integer, :null => false, :default => 0
    execute "update hits set blocked_ip = true where passed = false and analyzed = true"
    execute "update stats set blocked_ip = analyzed - passed"
    Rails.cache.clear
  end

  def self.down
    remove_column :hits, :forwarded_for
    remove_column :hits, :blocked_ip
    remove_column :hits, :blocked_proxy_ip
    remove_column :stats, :blocked_ip
    remove_column :stats, :blocked_proxy_ip
    Rails.cache.clear
  end
end
