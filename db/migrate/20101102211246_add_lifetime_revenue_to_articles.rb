class AddLifetimeRevenueToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :lifetime_revenue, :float
  end

  def self.down
    remove_column :articles, :lifetime_revenue
  end
end
