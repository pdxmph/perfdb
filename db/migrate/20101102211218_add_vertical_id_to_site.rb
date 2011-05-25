class AddVerticalIdToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :vertical_id, :integer


  end

  def self.down
    remove_column :sites, :vertical_id

  end
end
