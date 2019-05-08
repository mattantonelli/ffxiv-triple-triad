class AddNotesToDecks < ActiveRecord::Migration[5.2]
  def change
    add_column :decks, :notes, :string, limit: 1000
  end
end
