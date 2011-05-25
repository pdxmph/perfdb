class AddLegacyArticleToArticles < ActiveRecord::Migration
  def self.up

    add_column :articles, :legacy_content, :boolean


  end

  def self.down
    remove_column :articles, :legacy_content
  end
end
