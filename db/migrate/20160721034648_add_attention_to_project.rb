class AddAttentionToProject < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :attention, :boolean
  end
end
