class CreateNPCRewards < ActiveRecord::Migration[5.2]
  def change
    create_table :npc_rewards do |t|
      t.integer :npc_id, null: false
      t.integer :card_id, null: false

      t.timestamps

      t.index :npc_id
      t.index :card_id
    end
  end
end
