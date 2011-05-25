class AddReportableToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :is_reportable, :boolean, :default => 1
  end

  def self.down
    remove_column :sites, :is_reportable
  end
end
