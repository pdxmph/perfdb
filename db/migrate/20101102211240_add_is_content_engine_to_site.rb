class AddIsContentEngineToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :is_contentengine, :boolean, :default => 0

  end

  def self.down
    remove_column :sites, :is_contentengine
  end
end
