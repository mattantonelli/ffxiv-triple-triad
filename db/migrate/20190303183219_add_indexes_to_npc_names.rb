class AddIndexesToNPCNames < ActiveRecord::Migration[5.2]
  def up
    add_index :npcs, :name_en, unique: true
    add_index :npcs, :name_de, unique: true
    add_index :npcs, :name_fr, unique: true
    add_index :npcs, :name_ja, unique: true
  end

  def down
    remove_index :npcs, :name_en
    remove_index :npcs, :name_de
    remove_index :npcs, :name_fr
    remove_index :npcs, :name_ja
  end
end
