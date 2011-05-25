class AddContentTypeReportToSiteStat < ActiveRecord::Migration
  def self.up
    add_column :site_stats, :content_type_report, :text
  end

  def self.down
    remove_column :site_stats, :content_type_report
  end
end
