class CreateSources < ActiveRecord::Migration[5.2]
  def up
    create_table :sources do |t|
      t.integer :card_id
      t.string :origin
      t.string :name

      t.timestamps
    end
    add_index :sources, :card_id
    add_index :sources, :origin

    remove_column :cards, :source
  end

  def down
    drop_table :sources
    add_column :cards, :source, :string
  end
end
