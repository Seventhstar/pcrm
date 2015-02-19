class CreateProviderBudgets < ActiveRecord::Migration
  def change
    create_table :provider_budgets do |t|
      t.integer :provider_id
      t.integer :budget_id

      t.timestamps null: false
    end
    add_index :provider_budgets, :provider_id
    add_index :provider_budgets, :budget_id
  end
end
