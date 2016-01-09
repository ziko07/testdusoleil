class UrlAsMethod < ActiveRecord::Migration
  def self.up
    remove_column :campaigns, :url
  end

  def self.down
    add_column :campaigns, :url, :string
  end
end
