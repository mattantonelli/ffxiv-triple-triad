class AddIndexesToCards < ActiveRecord::Migration[5.2]
  def change
    add_index :cards, :stars
    add_index :cards, [:id, :patch]
  end
end
