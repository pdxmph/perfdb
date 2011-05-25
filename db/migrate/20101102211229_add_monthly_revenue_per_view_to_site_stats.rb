class AddMonthlyRevenuePerViewToSiteStats < ActiveRecord::Migration
  def self.up
    add_column :site_stats, :revenue_per_view, :integer
    
  end

  def self.down
    remove_column :site_stats, :revenue_per_view
  end
end
