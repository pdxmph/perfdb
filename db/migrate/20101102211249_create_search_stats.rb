class CreateSearchStats < ActiveRecord::Migration
  def self.up
    create_table :search_stats do |t|
      t.integer :site_id

      t.timestamps
    end
  end

  def self.down
    drop_table :search_stats
  end
end
