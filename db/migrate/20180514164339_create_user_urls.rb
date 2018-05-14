class CreateUserUrls < ActiveRecord::Migration[5.1]
  def change
    create_table :user_urls do |t|
      t.string :model
      t.text :params

      t.timestamps
    end
  end
end
