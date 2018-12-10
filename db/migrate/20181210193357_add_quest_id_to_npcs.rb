class AddQuestIdToNPCs < ActiveRecord::Migration[5.2]
  def change
    add_column :npcs, :quest_id, :integer
  end
end
