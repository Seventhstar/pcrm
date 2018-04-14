class CreateSpecialInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :special_infos do |t|
      t.text :content
      t.integer :special_info_id
      t.string :special_info_type

      t.timestamps
    end

    add_index :special_infos, [:special_info_id, :special_info_type]
  end
end
