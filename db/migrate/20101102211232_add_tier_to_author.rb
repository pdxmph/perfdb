class AddTierToAuthor < ActiveRecord::Migration

  def self.up

    add_column :authors, :tier, :integer

  end

  def self.down
    remove_column :authors, :tier
  end
end
