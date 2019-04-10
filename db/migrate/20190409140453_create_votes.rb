class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :deck_id
      t.integer :user_id
      t.integer :score, default: 1

      t.timestamps
    end
    add_index :votes, :deck_id
    add_index :votes, [:deck_id, :user_id], unique: true
  end
end
