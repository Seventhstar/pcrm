class CreateGoodsPriorities < ActiveRecord::Migration[5.1]
  def change
    create_table :goods_priorities do |t|
      t.string :name

      t.timestamps
    end
  end
end
