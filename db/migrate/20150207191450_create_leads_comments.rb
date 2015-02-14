class CreateLeadsComments < ActiveRecord::Migration
  def change
    create_table :leads_comments do |t|
      t.text :comment
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
