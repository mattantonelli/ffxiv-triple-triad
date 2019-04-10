class CreateDecks < ActiveRecord::Migration[5.2]
  def change
    create_table :decks do |t|
      t.integer :user_id
      t.integer :rule_id
      t.integer :npc_id

      t.timestamps
    end
    add_index :decks, :user_id
    add_index :decks, :rule_id
    add_index :decks, :npc_id
  end
end
