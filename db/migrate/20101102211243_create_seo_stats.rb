class CreateSeoStats < ActiveRecord::Migration
  def self.up
    create_table :seo_stats do |t|
      t.integer :site_id
      t.integer :google_pagerank
      t.integer :google_backlinks
      t.integer :yahoo_backlinks
      t.integer :bing_backlinks
      t.integer :alexa_backlinks
      t.date :gather_date

      t.timestamps
    end
  end

  def self.down
    drop_table :seo_stats
  end
end
