class AddMailServiceToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :is_sms, :boolean, :default => false
    add_column :campaigns, :mail_services, :string
    add_column :campaigns, :sent_mail, :boolean, :default => false
  end

  def self.down
    remove_column :campaigns, :is_sms
    remove_column :campaigns, :sent_mail
    remove_column :campaigns, :mail_services
  end
end
