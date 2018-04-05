class CreateAttachments < ActiveRecord::Migration[4.2]
  def change
    create_table :attachments do |t|
      t.integer :user_id
      t.integer :owner_id
      t.string :owner_type
      t.string :name

      t.timestamps null: false
    end
    add_index :attachments, :owner_id
  end
end
