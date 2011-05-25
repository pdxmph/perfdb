class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.integer :id
      t.string :word
      t.boolean :stop

      t.timestamps
    end
  end

  def self.down
    drop_table :topics
  end
end
