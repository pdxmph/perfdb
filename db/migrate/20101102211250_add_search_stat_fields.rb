class AddSearchStatFields < ActiveRecord::Migration
  def self.up
    add_column :search_stats, :google_us_visits, :integer
    add_column :search_stats, :google_non_us_visits, :integer
    add_column :search_stats, :bing_us_visits, :integer
    add_column :search_stats, :bing_non_us_visits, :integer
    add_column :search_stats, :yahoo_us_visits, :integer
    add_column :search_stats, :yahoo_non_us_visits, :integer
    add_column :search_stats, :direct_visits, :integer
    add_column :search_stats, :referred_visits, :integer
    add_column :search_stats, :record_date, :date
  end

  def self.down
    remove_column :search_stats, :record_date
    remove_column :search_stats, :google_us_visits
    remove_column :search_stats, :google_non_us_visits
    remove_column :search_stats, :bing_us_visits
    remove_column :search_stats, :bing_non_us_visits
    remove_column :search_stats, :yahoo_us_visits
    remove_column :search_stats, :yahoo_non_us_visits
    remove_column :search_stats, :direct_visits
    remove_column :search_stats, :referred_visits
  end
end
