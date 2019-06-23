class AddSpecToProvidersGroup < ActiveRecord::Migration[5.1]
  def change
    add_column :providers_groups, :spec, :string
  end
end
