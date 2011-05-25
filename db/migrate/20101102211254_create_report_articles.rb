class CreateReportArticles < ActiveRecord::Migration
  def self.up
    create_table :report_articles do |t|
      t.integer :id
      t.string :title
      t.date :pub_date
      t.string :path

      t.timestamps
    end
  end

  def self.down
    drop_table :report_articles
  end
end
