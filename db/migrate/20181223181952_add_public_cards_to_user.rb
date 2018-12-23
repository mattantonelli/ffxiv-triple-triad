class AddPublicCardsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :public_cards, :boolean, default: true
  end
end
