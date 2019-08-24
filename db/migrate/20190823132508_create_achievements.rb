class CreateAchievements < ActiveRecord::Migration[5.2]
  def change
    create_table :achievements do |t|
      t.string :name_en
      t.string :name_de
      t.string :name_fr
      t.string :name_ja
      t.string :description_en
      t.string :description_de
      t.string :description_fr
      t.string :description_ja
      t.integer :card_id

      t.timestamps
    end
    add_index :achievements, :card_id
  end
end
