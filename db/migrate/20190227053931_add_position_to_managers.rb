class AddPositionToManagers < ActiveRecord::Migration[5.1]
  def change
    add_reference :provider_managers, :position, default: 2
  end
end
