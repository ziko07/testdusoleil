class CreateBlockips < ActiveRecord::Migration
  def self.up
    create_table :blockips do |t|
      t.string :ip
      t.string :source
    end
  end

  def self.down
    drop_table :blockips
  end
end
