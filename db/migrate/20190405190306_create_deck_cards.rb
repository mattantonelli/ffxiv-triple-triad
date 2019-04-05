class CreateDeckCards < ActiveRecord::Migration[5.2]
  def change
    create_table :deck_cards do |t|
      t.integer :deck_id
      t.integer :card_id
      t.integer :position

      t.timestamps

      t.index :deck_id
      t.index :card_id
    end
  end
end
