class AddIspOrganizationToStats < ActiveRecord::Migration
  def self.up
    add_column :stats, :blocked_isp_organization, :integer, default: 0, :null => false    
  end

  def self.down
    remove_column :stats, :blocked_isp_organization
  end
end
