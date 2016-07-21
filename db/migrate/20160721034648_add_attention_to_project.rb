class AddAttentionToProject < ActiveRecord::Migration
  def change
    add_column :projects, :attention, :boolean
  end
end
