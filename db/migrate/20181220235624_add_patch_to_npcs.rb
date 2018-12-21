class AddPatchToNPCs < ActiveRecord::Migration[5.2]
  def change
    add_column :npcs, :patch, :string
    add_index :npcs, :patch
  end
end
