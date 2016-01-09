class BlankReferrer < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :filter_blank_referrer, :boolean, :default => false, :null => false 
  end

  def self.down
    remove_column :campaigns, :filter_blank_referrer
  end
end
