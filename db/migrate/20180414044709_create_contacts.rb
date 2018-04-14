class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.integer :contact_kind_id
      t.string :val
      t.string :who
      t.belongs_to :contactable, polymorphic: true

      t.timestamps
    end
    add_index :contacts, [:contactable_id, :contactable_type]
  end
end
