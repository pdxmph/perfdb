class AddCaptureDateToView < ActiveRecord::Migration
  def self.up

    add_column :views, :capture_date, :date

  end

  def self.down
    remove_column  :views, :capture_date, :date
  end
end
