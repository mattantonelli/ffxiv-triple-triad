class CreateNPCs < ActiveRecord::Migration[5.2]
  def change
    create_table :npcs do |t|
      t.string :name, null: false
      t.string :location
      t.integer :x
      t.integer :y
      t.string :rules
      t.string :quest
      t.integer :resident_id, null: false

      t.timestamps
    end
  end
end
