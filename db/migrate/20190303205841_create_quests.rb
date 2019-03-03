class CreateQuests < ActiveRecord::Migration[5.2]
  def up
    create_table :quests do |t|
      t.string :name_en
      t.string :name_de
      t.string :name_fr
      t.string :name_ja

      t.timestamps
    end

    remove_column :npcs, :quest
  end

  def down
    drop_table :quests
    add_column :npcs, :quest, :string
  end
end
