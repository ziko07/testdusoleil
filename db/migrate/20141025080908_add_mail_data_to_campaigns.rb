class AddMailDataToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :filter_organization_allow, :boolean, :default => false
    add_column :campaigns, :email_notification, :boolean, :default => false
    add_column :campaigns, :email, :string, :default => ""
    add_column :campaigns, :mail_description, :text, :default => ""
    add_column :campaigns, :mail_hit, :integer, :default => 0, :null => false
    change_column :campaigns, :filter_organization_other, :text
  end

  def self.down
    remove_column :campaigns, :filter_organization_allow
    remove_column :campaigns, :email_notification
    remove_column :campaigns, :mail_hit
    remove_column :campaigns, :mail_description
    remove_column :campaigns, :email
    change_column :campaigns, :filter_organization_other, :string
  end
end
