class DropVerticalTeamsTable < ActiveRecord::Migration
  def self.up
    drop_table :vertical_teams
  end

  def self.down
  end
end
