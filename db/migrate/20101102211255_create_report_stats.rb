class CreateReportStats < ActiveRecord::Migration
  def self.up
    create_table :report_stats do |t|
      t.integer :id
      t.integer :report_article_id
      t.date :report_date
      t.integer :pageviews

      t.timestamps
    end
  end

  def self.down
    drop_table :report_stats
  end
end
