class AddVisitorsToSiteStats < ActiveRecord::Migration
  def self.up
    add_column :site_stats, :vistors, :integer
    
  end

  def self.down
    remove_column :site_stats, :vistors, :integer
  end
end
