class DropUnneededTables < ActiveRecord::Migration
  def self.up
    drop_table :article_keywords
    drop_table :report_article_topics
  end

  def self.down
    create_table "report_article_topics", :id => false, :force => true do |t|
      t.integer  "report_article_id"
      t.integer  "topic_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "article_keywords", :force => true do |t|
      t.integer  "article_id"
      t.integer  "keyword_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
  end
end
