class DropGmTable < ActiveRecord::Migration
  def self.up
    drop_table :general_managers
    drop_table :producers
    
  end

  def self.down
    create_table "producers", :force => true do |t|
      t.text     "name"
      t.text     "email"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "general_managers", :force => true do |t|
      t.text     "name"
      t.text     "email"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
  end
end
