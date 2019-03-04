class CreateLocations < ActiveRecord::Migration[5.2]
  def up
    create_table :locations do |t|
      t.string :name_en, null: false
      t.string :name_de, null: false
      t.string :name_fr, null: false
      t.string :name_ja, null: false
      t.string :region_en, null: false
      t.string :region_de, null: false
      t.string :region_fr, null: false
      t.string :region_ja, null: false

      t.timestamps
    end

    add_index :locations, :name_en, unique: true
    add_index :locations, :name_de, unique: true
    add_index :locations, :name_fr, unique: true
    add_index :locations, :name_ja, unique: true
    add_index :locations, :region_en
    add_index :locations, :region_de
    add_index :locations, :region_fr
    add_index :locations, :region_ja

    remove_column :npcs, :location
    add_column :npcs, :location_id, :integer, null: false
    add_index :npcs, :location_id
  end

  def down
    drop_table :locations

    remove_column :npcs, :location_id
    add_column :npcs, :location, :string
  end
end
