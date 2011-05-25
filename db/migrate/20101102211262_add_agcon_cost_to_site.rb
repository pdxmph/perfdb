class AddAgconCostToSite < ActiveRecord::Migration
  def self.up

    add_column :sites, :agcon_cost, :float

  end

  def self.down
    remove_column :sites, :agcon_cost
  end
end
