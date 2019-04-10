class AddRatingToDecks < ActiveRecord::Migration[5.2]
  def change
    add_column :decks, :rating, :integer
  end
end
