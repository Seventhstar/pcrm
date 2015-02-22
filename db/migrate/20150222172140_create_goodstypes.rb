class CreateGoodstypes < ActiveRecord::Migration
  def change
    create_table :goodstypes do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
