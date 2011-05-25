class DropCtAndCsColumnsFromArticles < ActiveRecord::Migration
  def self.up
    remove_column :articles, :cs
    remove_column :articles, :ct
  end

  def self.down
    add_column :articles, :cs, :text
    add_column :articles, :ct, :text
  end
end
