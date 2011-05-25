class AddVisitsToSocialStats < ActiveRecord::Migration
  def self.up
    add_column :social_stats, :visits, :integer
  end

  def self.down
    remove_column :social_stats, :visits
  end
end
