class AddIsGroupToProviders < ActiveRecord::Migration[5.1]
  def change
    add_column :providers, :is_group, :boolean
  end
end
