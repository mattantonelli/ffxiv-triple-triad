class AddTranslationsToCards < ActiveRecord::Migration[5.2]
  def up
    puts 'Deleting all cards. Run the following to reload card data - rake cards:create'
    Card.delete_all

    remove_column :cards, :name
    remove_column :cards, :description

    add_column :cards, :name_en, :string, null: false
    add_column :cards, :name_de, :string, null: false
    add_column :cards, :name_fr, :string, null: false
    add_column :cards, :name_ja, :string, null: false

    add_column :cards, :description_en, :text, null: false
    add_column :cards, :description_de, :text, null: false
    add_column :cards, :description_fr, :text, null: false
    add_column :cards, :description_ja, :text, null: false

    add_index :cards, :name_en, unique: true
    add_index :cards, :name_de, unique: true
    add_index :cards, :name_fr, unique: true
    add_index :cards, :name_ja, unique: true
  end

  def down
    puts 'Deleting all cards. Run the following to reload card data - rake cards:create'
    Card.delete_all

    remove_column :cards, :name_en
    remove_column :cards, :name_de
    remove_column :cards, :name_fr
    remove_column :cards, :name_ja

    remove_column :cards, :description_en
    remove_column :cards, :description_de
    remove_column :cards, :description_fr
    remove_column :cards, :description_ja

    add_column :cards, :name, :string, null: false
    add_column :cards, :description, :text, null: false
    add_index :cards, :name, unique: true
  end
end
