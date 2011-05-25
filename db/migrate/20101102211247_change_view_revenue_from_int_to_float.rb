class ChangeViewRevenueFromIntToFloat < ActiveRecord::Migration
  def self.up
    change_column :views, :revenue, :float
  end

  def self.down
    change_column :views, :revenue, :string
  end
end
