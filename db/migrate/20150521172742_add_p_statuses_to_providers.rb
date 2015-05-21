class AddPStatusesToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :p_status_id, :integer
  end
end
