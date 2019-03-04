class CreateRules < ActiveRecord::Migration[5.2]
  def change
    create_table :rules do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.string :description_en, null: false
      t.string :description_de, null: false
      t.string :description_fr, null: false
      t.string :description_ja, null: false

      t.timestamps
    end

    add_index :rules, :name_en, unique: true
    add_index :rules, :name_de, unique: true
    add_index :rules, :name_fr, unique: true
    add_index :rules, :name_ja, unique: true
  end
end
