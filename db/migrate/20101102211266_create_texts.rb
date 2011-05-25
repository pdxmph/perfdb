class CreateTexts < ActiveRecord::Migration
  def self.up
    create_table :texts do |t|
      t.timestamps
      t.integer :article_id
      t.text :article_text
    end
  end

  def self.down
    drop_table :texts
  end
end
