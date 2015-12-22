class CreateAbsences < ActiveRecord::Migration
  def change
    create_table :absences do |t|
      t.integer :user_id
      t.datetime :from
      t.datetime :to
      t.integer :reason_id
      t.integer :new_reason_id
      t.text :comment
      t.integer :project_id

      t.timestamps null: false
    end
  end
end
