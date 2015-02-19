class CreateProviderStyles < ActiveRecord::Migration
  def change
    create_table :provider_styles do |t|
      t.belongs_to :provider
      t.belongs_to :style

      t.timestamps
    end
    add_index :provider_styles, :provider_id
    add_index :provider_styles, :style_id
  end
end
