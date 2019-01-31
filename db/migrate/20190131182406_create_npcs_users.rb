class CreateNPCsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :npcs_users do |t|
      t.integer :user_id
      t.integer :npc_id
    end
    add_index :npcs_users, :user_id
    add_index :npcs_users, :npc_id
    add_index :npcs_users, [:user_id, :npc_id], unique: true
  end
end
