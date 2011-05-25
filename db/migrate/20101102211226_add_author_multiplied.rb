class AddAuthorMultiplied < ActiveRecord::Migration
  def self.up
    add_column :editors, :multiplied, :boolean
  end

  def self.down
    remove_column :editors, :multiplied
  end
end
