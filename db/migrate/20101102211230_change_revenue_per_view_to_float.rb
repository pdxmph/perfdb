class ChangeRevenuePerViewToFloat < ActiveRecord::Migration
  def self.up
    change_table :site_stats do |t|
      t.change :revenue_per_view, :float
    end
  end



  def self.down
  end
end
