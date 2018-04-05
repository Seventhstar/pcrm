class CreateLeadsFiles < ActiveRecord::Migration[4.2]
  def change
    create_table :leads_files do |t|
      t.string :name
      t.integer	:lead_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
