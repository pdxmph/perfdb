class AddPageRankToSiteStats < ActiveRecord::Migration
  def self.up
    add_column :site_stats, :pagerank, :integer
  end

  def self.down
    remove_column :site_stats, :pagerank
  end
end
