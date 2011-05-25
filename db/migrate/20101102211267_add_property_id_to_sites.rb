class AddPropertyIdToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :web_property_id, :string

  end

  def self.down
    remove_column :sites, :web_property_id
  end
end
