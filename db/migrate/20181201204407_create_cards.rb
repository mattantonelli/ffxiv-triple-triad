class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :patch, null: false
      t.integer :card_type_id, null: false
      t.integer :stars, null: false
      t.integer :top, null: false
      t.integer :right, null: false
      t.integer :bottom, null: false
      t.integer :left, null: false
      t.integer :buy_price
      t.integer :sell_price, null: false
      t.string :source

      t.timestamps

      t.index :name, unique: true
      t.index :card_type_id
    end
  end
end
