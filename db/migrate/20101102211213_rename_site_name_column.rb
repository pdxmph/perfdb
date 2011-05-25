class RenameSiteNameColumn < ActiveRecord::Migration
  def self.up

    rename_column :sites, :site_name, :name

  end

  def self.down
    rename_column :sites, :name, :site_name
  end
end
