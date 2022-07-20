class AddDecimalsToNPCCoordinates < ActiveRecord::Migration[6.1]
  def change
    change_column :npcs, :x, :decimal, precision: 3, scale: 1
    change_column :npcs, :y, :decimal, precision: 3, scale: 1
  end
end
