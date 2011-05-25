class RenameVistorsToVisitorsInSiteStats < ActiveRecord::Migration
  def self.up
    rename_column :site_stats, :vistors, :visitors
  end

  def self.down
    rename_column :site_stats, :visitors, :vistors
  end
end
