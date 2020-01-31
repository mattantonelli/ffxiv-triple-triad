class AddDifficultyToNPCs < ActiveRecord::Migration[5.2]
  def change
    add_column :npcs, :difficulty, :decimal, precision: 3, scale: 2
  end
end
