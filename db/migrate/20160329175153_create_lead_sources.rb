class CreateLeadSources < ActiveRecord::Migration[4.2]
  def change
    create_table :lead_sources do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
