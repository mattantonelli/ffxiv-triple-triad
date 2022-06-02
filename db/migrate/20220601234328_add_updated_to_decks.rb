class AddUpdatedToDecks < ActiveRecord::Migration[6.1]
  def up
    add_column :decks, :updated, :boolean, default: true
    add_index :decks, :updated
    Deck.where('updated_at < ?', '2021-04-12').update_all(updated: false)
  end

  def down
    remove_index :decks, :updated
    remove_column :decks, :updated
  end
end
