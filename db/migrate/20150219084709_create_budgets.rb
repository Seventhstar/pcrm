class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
