class CreateSocialStats < ActiveRecord::Migration
  def self.up
    create_table :social_stats do |t|
      t.integer :social_site_id
      t.integer :site_id
      t.date :month
      t.integer :pageviews
      t.float :bouncerate

      t.timestamps
    end
  end

  def self.down
    drop_table :social_stats
  end
end
