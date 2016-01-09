class HitsArchive < ActiveRecord::Migration
  def self.up
    execute "create table if not exists hits_archive like hits"
  end

  def self.down
  end
end
