class AddCityToProjects < ActiveRecord::Migration[5.1]
  def change
    add_reference :projects, :city, default: 1
  end
end
