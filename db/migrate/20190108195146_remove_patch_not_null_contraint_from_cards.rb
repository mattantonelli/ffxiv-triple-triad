class RemovePatchNotNullContraintFromCards < ActiveRecord::Migration[5.2]
  def up
    change_column_null :cards, :patch, true
  end

  def down
    change_column_null :cards, :patch, false
  end
end
