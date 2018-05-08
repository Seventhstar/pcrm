class CreateWorkLinkers < ActiveRecord::Migration[5.1]
  def change
    create_table :work_linkers do |t|
      t.belongs_to :work
      t.belongs_to :linked_work
      t.index [:work_id, :linked_work_id], unique: true
      t.timestamps
    end
  end
end
