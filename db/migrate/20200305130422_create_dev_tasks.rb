class CreateDevTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :dev_tasks do |t|
      t.string :name
      t.integer :develop_id
      t.boolean :done
      t.boolean :uploaded
      t.boolean :checked

      t.timestamps
    end
  end
end
