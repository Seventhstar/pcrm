class AddPricesToProject < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :designer_price, :integer
    add_column :projects, :designer_price_2, :integer
    add_column :projects, :visualer_price, :integer
    add_column :projects, :visualer_id, :integer
  end
end
