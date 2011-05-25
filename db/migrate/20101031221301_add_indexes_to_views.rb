class AddIndexesToViews < ActiveRecord::Migration
  def self.up
    add_index :views, :article_id, :name => 'article_id_idx'
    
  end

  def self.down
      remove_index :views, :article_id, :name => 'article_id_idx'
  end
end
