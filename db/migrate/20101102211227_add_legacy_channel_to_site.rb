class AddLegacyChannelToSite < ActiveRecord::Migration
  def self.up
    
    add_column :sites, :legacy_channel, :text
    

  end

  def self.down
    remove_column :sites, :legacy_channel
  end
end
