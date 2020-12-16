class AddDeckOrderToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :deck_order, :integer
    add_index :cards, :deck_order
  end
end
