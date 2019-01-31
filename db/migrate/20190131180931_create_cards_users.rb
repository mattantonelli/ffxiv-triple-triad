class CreateCardsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :cards_users do |t|
      t.integer :user_id
      t.integer :card_id
    end
    add_index :cards_users, :user_id
    add_index :cards_users, :card_id
    add_index :cards_users, [:user_id, :card_id], unique: true
  end
end
