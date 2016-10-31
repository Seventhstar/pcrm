class AddVisToProject < ActiveRecord::Migration
  def change
    add_column :projects, :visualer_id, :integer
  end
end
