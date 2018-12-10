class AddSortIdToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :sort_id, :integer
    add_index :cards, :sort_id
  end
end
