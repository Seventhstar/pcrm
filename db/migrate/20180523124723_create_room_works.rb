class CreateRoomWorks < ActiveRecord::Migration[5.1]
  def change
    create_table :room_works do |t|
      t.references :room, foreign_key: true
      t.references :work, foreign_key: true

      t.timestamps
    end
  end
end
