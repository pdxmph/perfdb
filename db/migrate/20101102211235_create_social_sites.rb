class CreateSocialSites < ActiveRecord::Migration
  def self.up
    create_table :social_sites do |t|
      t.string :name
      t.string :domain

      t.timestamps
    end
  end

  def self.down
    drop_table :social_sites
  end
end
