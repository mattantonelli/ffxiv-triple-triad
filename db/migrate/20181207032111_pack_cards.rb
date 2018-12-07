class PackCards < ActiveRecord::Migration[5.2]
  def change
    create_table :pack_cards do |t|
      t.integer :pack_id, null: false
      t.integer :card_id, null: false

      t.timestamps

      t.index :pack_id
      t.index :card_id
    end
  end
end
