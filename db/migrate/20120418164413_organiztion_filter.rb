class OrganiztionFilter < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :filter_organization_facebook, :boolean, :default => false, :null => false
    add_column :campaigns, :filter_organization_google, :boolean, :default => false, :null => false
    add_column :campaigns, :filter_organization_msn, :boolean, :default => false, :null => false
    add_column :campaigns, :filter_organization_other, :string
    add_column :hits, :blocked_organization, :boolean, :default => false, :null => false
    # add_column :hits_archive, :blocked_organization, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :campaigns, :filter_organization_facebook
    remove_column :campaigns, :filter_organization_google
    remove_column :campaigns, :filter_organization_msn
    remove_column :campaigns, :filter_organization_other
    remove_column :hits, :blocked_organization
    # remove_column :hits_archive, :blocked_organization
  end
end
