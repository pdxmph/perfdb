class AddArticleEditorId < ActiveRecord::Migration
  def self.up
    add_column :articles, :editor_id, :integer
  end

  def self.down
    remove_column :articles, :editor_id
  end
end
