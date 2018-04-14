class CreateContactKinds < ActiveRecord::Migration[5.1]
  def change
    create_table :contact_kinds do |t|
      t.string :name

      t.timestamps
    end
  end
end
