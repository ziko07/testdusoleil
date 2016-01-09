class SetTrafficTypeDefaults < ActiveRecord::Migration
  def self.up
    execute "update campaigns set traffic_type = 'other'"
  end

  def self.down
  end
end
