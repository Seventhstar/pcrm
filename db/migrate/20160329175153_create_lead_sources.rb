class CreateLeadSources < ActiveRecord::Migration
  def change
    create_table :lead_sources do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
