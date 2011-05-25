class AddAgconStatsToSiteStats < ActiveRecord::Migration
  def self.up
    add_column :site_stats, :agcon_bounce_rate, :integer
    add_column :site_stats, :agcon_pageviews, :integer
    
  end

  def self.down
    remove_column :site_stats, :agcon_pageviews
    remove_column :site_stats, :agcon_bounce_rate
  end
end
