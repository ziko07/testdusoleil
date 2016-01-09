class Campaigndomainfilter < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :filter_domain_google, :boolean, :default => false, :null => false
    add_column :campaigns, :filter_domain_facebook, :boolean, :default => false, :null => false
    add_column :campaigns, :filter_domain_msn, :boolean, :default => false, :null => false
    add_column :campaigns, :filter_domain_other, :string, :default => "", :null => false
  end

  def self.down
    remove_column :campaigns, :filter_domain_google
    remove_column :campaigns, :filter_domain_facebook
    remove_column :campaigns, :filter_domain_msn
    remove_column :campaigns, :filter_domain_other
  end
end
