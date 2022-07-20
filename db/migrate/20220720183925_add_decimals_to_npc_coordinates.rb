class AddDecimalsToNPCCoordinates < ActiveRecord::Migration[6.1]
  def up
    change_column :npcs, :x, :decimal, precision: 3, scale: 1
    change_column :npcs, :y, :decimal, precision: 3, scale: 1
  end

  def down
    change_column :npcs, :x, :integer
    change_column :npcs, :y, :integer
  end
end
