class AddFormattedNumberToCards < ActiveRecord::Migration[6.1]
  def change
    add_column :cards, :formatted_number, :string, null: false
  end
end
