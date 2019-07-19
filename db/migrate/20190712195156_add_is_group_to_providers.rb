class AddIsGroupToProviders < ActiveRecord::Migration[5.1]
  def change
    add_column :providers, :is_group, :boolean
    add_column :providers, :group_id, :bigint
  end
end
