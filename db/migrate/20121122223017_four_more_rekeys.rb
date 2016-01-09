class FourMoreRekeys < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :rekey_from_3, :string
    add_column :campaigns, :rekey_from_4, :string
    add_column :campaigns, :rekey_from_5, :string
    add_column :campaigns, :rekey_from_6, :string
    add_column :campaigns, :rekey_to_3, :string
    add_column :campaigns, :rekey_to_4, :string
    add_column :campaigns, :rekey_to_5, :string
    add_column :campaigns, :rekey_to_6, :string
  end

  def self.down
    remove_column :campaigns, :rekey_from_3
    remove_column :campaigns, :rekey_from_4
    remove_column :campaigns, :rekey_from_5
    remove_column :campaigns, :rekey_from_6
    remove_column :campaigns, :rekey_to_3
    remove_column :campaigns, :rekey_to_4
    remove_column :campaigns, :rekey_to_5
    remove_column :campaigns, :rekey_to_6
  end
end
