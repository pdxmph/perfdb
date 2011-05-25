class RemoveEditorIdColumnFromArticles < ActiveRecord::Migration
  def self.up

    remove_column :articles, :editor_id

  end

  def self.down
    add_column :articles, :editor_id, :integer
    
  end
end
