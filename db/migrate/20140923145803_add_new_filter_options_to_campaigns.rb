class AddNewFilterOptionsToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :filter_domain_allow, :boolean, :default => false, :null => false
    add_column :campaigns, :filter_broad_match, :boolean, :default => false, :null => false
    add_column :campaigns, :filter_exact_match, :boolean, :default => false, :null => false    
  end

  def self.down
    remove_column :campaigns, :filter_exact_match
    remove_column :campaigns, :filter_broad_match
    remove_column :campaigns, :filter_domain_allow
  end
end
