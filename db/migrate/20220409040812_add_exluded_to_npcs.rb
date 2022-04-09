class AddExludedToNPCs < ActiveRecord::Migration[6.1]
  def change
    add_column :npcs, :excluded, :boolean, default: false
  end
end
