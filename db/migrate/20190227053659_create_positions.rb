class CreatePositions < ActiveRecord::Migration[5.1]
  def change
    create_table :positions do |t|
      t.string :name
      t.boolean :secret, default: false

      t.timestamps
    end
  end
end
