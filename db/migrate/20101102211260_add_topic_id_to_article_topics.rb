class AddTopicIdToArticleTopics < ActiveRecord::Migration
  def self.up
    add_column :article_topics, :topic_id, :integer
  end

  def self.down
    remove_column :article_topics, :topic_id
  end
end
