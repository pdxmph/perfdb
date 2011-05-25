class AddAllPageviewsToSearchStats < ActiveRecord::Migration

  def self.up
    add_column :search_stats, :total_pageviews, :integer
  end

  def self.down
    remove_column :search_stats, :column_name
  end
end
