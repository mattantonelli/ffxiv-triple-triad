class FixCardsOrder < ActiveRecord::Migration[5.2]
  def up
    rename_column :cards, :sort_id, :order
    add_column :cards, :order_group, :integer
    add_index :cards, :order_group
  end

  def down
    rename_column :cards, :order, :sort_id
    remove_index :cards, :order_group
    remove_column :cards, :order_group
  end
end
