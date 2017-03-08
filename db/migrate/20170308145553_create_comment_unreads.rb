class CreateCommentUnreads < ActiveRecord::Migration
  def change
    create_table :comment_unreads do |t|
      t.integer :comment_id
      t.integer :user_id

      t.timestamps null: false  
    end
    add_index :comment_unreads, :comment_id
  end
end
