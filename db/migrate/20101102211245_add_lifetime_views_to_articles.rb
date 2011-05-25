class AddLifetimeViewsToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :lifetime_views, :integer
  end

  def self.down
    remove_column :articles, :lifetime_views
  end
end
