class RemoveRulesFromNPCs < ActiveRecord::Migration[5.2]
  def up
    remove_column :npcs, :rules
  end

  def down
    add_column :npcs, :rules, :string
  end
end
