class CreateInstances < ActiveRecord::Migration[5.2]
  def change
    create_table :instances do |t|
      t.string :name_en
      t.string :name_de
      t.string :name_fr
      t.string :name_ja
      t.string :duty_type

      t.timestamps
    end
    add_index :instances, :name_en
  end
end
