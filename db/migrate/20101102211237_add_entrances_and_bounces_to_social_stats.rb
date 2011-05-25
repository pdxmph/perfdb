class AddEntrancesAndBouncesToSocialStats < ActiveRecord::Migration
  def self.up
    add_column :social_stats, :unique_views, :integer
    add_column :social_stats, :entrances, :integer
  end

  def self.down
    remove_column :social_stats, :entrances
    remove_column :social_stats, :unique_views
  end
end
