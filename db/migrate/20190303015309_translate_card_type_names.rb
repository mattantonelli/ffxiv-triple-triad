class TranslateCardTypeNames < ActiveRecord::Migration[5.2]
  def up
    puts 'Deleting all card types. Run the following to reload card data - rake card_types:create'
    CardType.delete_all

    remove_column :card_types, :name

    add_column :card_types, :name_en, :string, null: false
    add_column :card_types, :name_de, :string, null: false
    add_column :card_types, :name_fr, :string, null: false
    add_column :card_types, :name_ja, :string, null: false

    add_index :card_types, :name_en, unique: true
    add_index :card_types, :name_de, unique: true
    add_index :card_types, :name_fr, unique: true
    add_index :card_types, :name_ja, unique: true
  end

  def down
    puts 'Deleting all card types. Run the following to reload card data - rake card_types:create'
    CardType.delete_all

    remove_column :card_types, :name_en
    remove_column :card_types, :name_de
    remove_column :card_types, :name_fr
    remove_column :card_types, :name_ja

    add_column :card_types, :name, :string, null: false
    add_index :card_types, :name, unique: true
  end
end
