class AddArticleFlagNote < ActiveRecord::Migration
  def self.up
    add_column :articles, :flag_note, :text
    
  end

  def self.down
    remove_column :articles, :flag_note
  end
end
