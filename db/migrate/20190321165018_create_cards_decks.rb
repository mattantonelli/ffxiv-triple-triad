class CreateCardsDecks < ActiveRecord::Migration[5.2]
  def change
    create_table :cards_decks do |t|
      t.integer :card_id
      t.integer :deck_id
    end
    add_index :cards_decks, :card_id
    add_index :cards_decks, :deck_id
  end
end
