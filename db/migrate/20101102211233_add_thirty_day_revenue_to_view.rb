class AddThirtyDayRevenueToView < ActiveRecord::Migration
  def self.up
    add_column :views, :thirty_day_revenue, :float
  end

  def self.down
    remove_column :views, :thirty_day_revenue
  end
end
