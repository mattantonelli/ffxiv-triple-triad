class RemoveUniqueNameIndexFromCards < ActiveRecord::Migration[6.1]
  def up
    remove_index :cards, :name_en
    remove_index :cards, :name_de
    remove_index :cards, :name_fr
    remove_index :cards, :name_ja

    add_index :cards, :name_en
    add_index :cards, :name_de
    add_index :cards, :name_fr
    add_index :cards, :name_ja
  end

  def down
    add_index :cards, :name_en, unique: true
    add_index :cards, :name_de, unique: true
    add_index :cards, :name_fr, unique: true
    add_index :cards, :name_ja, unique: true
  end
end
