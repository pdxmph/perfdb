class AddPriorityAnalyticsToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :priority_report, :boolean, :default => false
  end

  def self.down
    remove_column :sites, :priority_report
  end
end
