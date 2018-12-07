class CreatePacks < ActiveRecord::Migration[5.2]
  def change
    create_table :packs do |t|
      t.string :name, null: false
      t.integer :cost, null: false

      t.timestamps
    end
    add_index :packs, :name, unique: true
  end
end
