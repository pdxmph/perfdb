class CreateReportArticleTopics < ActiveRecord::Migration
  def self.up
    create_table :report_article_topics, :id => false do |t|
      t.integer :report_article_id
      t.integer :topic_id

      t.timestamps
    end
  end

  def self.down
    drop_table :report_article_topics
  end
end
