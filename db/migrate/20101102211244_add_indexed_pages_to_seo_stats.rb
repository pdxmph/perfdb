class AddIndexedPagesToSeoStats < ActiveRecord::Migration

  def self.up

    add_column :seo_stats, :google_indexed_pages, :int
    add_column :seo_stats, :yahoo_indexed_pages, :int
    add_column :seo_stats, :bing_indexed_pages, :int

  end

  def self.down
    remove_column :seo_stats, :bing_indexed_pages
    remove_column :seo_stats, :yahoo_indexed_pages
    remove_column :seo_stats, :google_indexed_pages
  end
end
