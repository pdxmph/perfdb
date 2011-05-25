class AddEditorEffortMultiplier < ActiveRecord::Migration
  def self.up

    add_column :editors, :effort_multiplier, :float
    
  end

  def self.down
    remove_column :editors, :effort_multiplier
  end
end
