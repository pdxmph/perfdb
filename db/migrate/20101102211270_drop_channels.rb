class DropChannels < ActiveRecord::Migration
  def self.up
    drop_table :channels

  end

  def self.down
    create_table "channels", :force => true do |t|
      t.text "name"
    end
    
  end
end
