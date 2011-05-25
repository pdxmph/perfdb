class AddHasRevenuetoSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :has_revenue, :boolean

  end

  def self.down
    remove_column :sites, :has_revenue


  end
end
