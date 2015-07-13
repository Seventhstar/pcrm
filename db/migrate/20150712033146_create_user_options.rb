class CreateUserOptions < ActiveRecord::Migration
  def change
    create_table :user_options do |t|
      t.integer :user_id
      t.integer :option_id
      t.string :value

      t.timestamps null: false
    end
  end
end
