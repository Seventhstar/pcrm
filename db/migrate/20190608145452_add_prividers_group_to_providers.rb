class AddPrividersGroupToProviders < ActiveRecord::Migration[5.1]
  def change
    add_reference :providers, :providers_group, foreign_key: true
  end
end
