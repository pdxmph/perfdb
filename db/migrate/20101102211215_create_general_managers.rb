class CreateGeneralManagers < ActiveRecord::Migration
  def self.up
    create_table :general_managers do |t|
      t.integer :id
      t.text :name
      t.text :email

      t.timestamps
    end
  end

  def self.down
    drop_table :general_managers
  end
end
