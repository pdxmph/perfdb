class AddBouncesToSocialStats < ActiveRecord::Migration
  def self.up
    add_column :social_stats, :bounces, :integer
  end

  def self.down
    remove_column :social_stats, :bounces
  end
end
