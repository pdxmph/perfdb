class AddSiteIdToTrackedArticles < ActiveRecord::Migration
  def self.up

    add_column :report_articles, :site_id, :integer

  end

  def self.down
    remove_column :report_articles, :site_id
  end
end
