class AddGeneralManagerTable < ActiveRecord::Migration
  def self.up
     create_table :general_managers do |t|
              t.string  :name
              t.string  :email
            end
  end

  def self.down
    
     drop_table :general_managers
  end
end
