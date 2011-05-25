class AddEditorIndexToArticles < ActiveRecord::Migration
  def self.up
    add_index :articles, :editor_id, :name => 'editor_id_idx'
    
  end

  def self.down
    remove_index :articles, :editor_id, :name => 'editor_id_idx'
  end
end
