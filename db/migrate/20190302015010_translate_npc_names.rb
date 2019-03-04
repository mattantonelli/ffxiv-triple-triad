class TranslateNPCNames < ActiveRecord::Migration[5.2]
  def up
    puts 'Deleting all NPCs. Run the following to reload card data - rake npcs:create'
    NPC.delete_all

    remove_column :npcs, :name

    add_column :npcs, :name_en, :string, null: false
    add_column :npcs, :name_de, :string, null: false
    add_column :npcs, :name_fr, :string, null: false
    add_column :npcs, :name_ja, :string, null: false
  end

  def down
    puts 'Deleting all NPCs. Run the following to reload card data - rake npcs:create'
    NPC.delete_all

    remove_column :npcs, :name_en, :string, null: false
    remove_column :npcs, :name_de, :string, null: false
    remove_column :npcs, :name_fr, :string, null: false
    remove_column :npcs, :name_ja, :string, null: false

    add_column :npcs, :name, :string, null: false
  end
end
