class AddViewRevenueToViews < ActiveRecord::Migration
  def self.up
    add_column :views, :revenue, :integer
  end

  def self.down
    remove_column :views, :revenue
  end
end
