class CreateBudgets < ActiveRecord::Migration[4.2]
  def change
    create_table :budgets do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
