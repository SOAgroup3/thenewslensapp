class CreateTutorials < ActiveRecord::Migration
  def self.up
    create_table :tutorials do |t|
      t.string :number
      t.timestamps
    end
  end

  def self.down
    drop_table :tutorials
  end
end