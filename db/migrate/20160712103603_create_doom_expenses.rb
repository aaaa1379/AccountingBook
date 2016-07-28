class CreateDoomExpenses < ActiveRecord::Migration
  def change
    create_table :doom_expenses do |t|
      t.string :item
      t.integer :income
      t.integer :expense
      t.integer :total
      t.text :note
      t.timestamp :delete_at

      t.timestamps null: false
    end
  end
end
