class AddDistinctContentFieldsToSites < ActiveRecord::Migration
  def self.up

    add_column :sites, :distinct_articles, :integer
    add_column :sites, :article_occurences, :integer
    add_column :sites, :copied_articles, :integer

  end

  def self.down
    remove_column :sites, :article_occurences
    remove_column :sites, :copied_articles
    remove_column :sites, :distinct_articles
  end
end
