class CreateCurrencies < ActiveRecord::Migration[5.1]
  def change
    create_table :currencies do |t|
      t.string :name
      t.string :short
      t.string :code

      t.timestamps
    end
  end
end
