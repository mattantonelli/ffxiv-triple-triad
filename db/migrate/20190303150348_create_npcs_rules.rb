class CreateNPCsRules < ActiveRecord::Migration[5.2]
  def change
    create_table :npcs_rules do |t|
      t.integer :npc_id
      t.integer :rule_id
    end

    add_index :npcs_rules, :npc_id
    add_index :npcs_rules, :rule_id
    add_index :npcs_rules, [:npc_id, :rule_id], unique: true
  end
end
