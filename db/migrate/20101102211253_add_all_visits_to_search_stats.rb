class AddAllVisitsToSearchStats < ActiveRecord::Migration
  def self.up
    add_column :search_stats, :total_visits, :integer

  end

  def self.down
    remove_column :search_stats, :total_visits
  end
end
