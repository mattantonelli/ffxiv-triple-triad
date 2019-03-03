class TranslatePackNames < ActiveRecord::Migration[5.2]
  def up
    puts 'Deleting all card packs. Run the following to reload card data - rake card_packs:create'
    Pack.delete_all

    remove_column :packs, :name

    add_column :packs, :name_en, :string, null: false
    add_column :packs, :name_de, :string, null: false
    add_column :packs, :name_fr, :string, null: false
    add_column :packs, :name_ja, :string, null: false

    add_index :packs, :name_en, unique: true
    add_index :packs, :name_de, unique: true
    add_index :packs, :name_fr, unique: true
    add_index :packs, :name_ja, unique: true
  end
  
  def down
    puts 'Deleting all card packs. Run the following to reload card data - rake card_packs:create'
    Pack.delete_all

    remove_column :packs, :name_en
    remove_column :packs, :name_de
    remove_column :packs, :name_fr
    remove_column :packs, :name_ja

    add_column :packs, :name, :string, null: false
    add_index :packs, :name, unique: true
  end
end
