class CreateProvidersGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :providers_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
