class AddPStatusesToProviders < ActiveRecord::Migration[4.2]
  def change
    add_column :providers, :p_status_id, :integer
  end
end
