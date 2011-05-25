class AddContentSourceReportToSiteStat < ActiveRecord::Migration
  def self.up
    add_column :site_stats, :content_source_report, :text
    
  end

  def self.down
    remove_column :site_stats, :content_source_report
  end
end
