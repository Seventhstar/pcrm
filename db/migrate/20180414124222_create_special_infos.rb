class CreateSpecialInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :special_infos do |t|
      t.text :content
      t.belongs_to :specialable, polymorphic: true

      t.timestamps
    end

    add_index :special_infos, [:specialable_id, :specialable_type]
  end
end
