class AddIndexesToArticles < ActiveRecord::Migration
  def self.up
   # add_index :articles, :pub_date, :name => 'pub_date_idx'
  #  add_index :articles, :title, :name => 'title_idx'
    add_index :articles, :content_type_id, :name => 'content_type_id_idx'
    add_index :articles, :content_source_id, :name => 'content_source_id_idx'
    add_index :articles, :author_id, :name => 'author_id_idx'
    add_index :articles, :site_id, :name => 'site_id_idx'
  end

  def self.down
   # remove_index :articles, :pub_date, :name => 'pub_date_idx'
    #remove_index :articles, :title, :name => 'title_idx'
    remove_index :articles, :content_type_id, :name => 'content_type_id_idx'
    remove_index :articles, :content_source_id, :name => 'content_source_id_idx'
    remove_index :articles, :author_id, :name => 'author_id_idx'
    remove_index :articles, :site_id, :name => 'site_id_idx'
  end
end
