class DropThirtyDayRevenueFromViews < ActiveRecord::Migration
  def self.up

    remove_column :views, :thirty_day_revenue
  end

  def self.down
    add_column :views, :thirty_day_revenue, :float
  end
end
