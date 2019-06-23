class MakePolymorphicToProviderGoodstype < ActiveRecord::Migration[5.1]
  def change
     rename_column :provider_goodstypes, :provider_id, :owner_id
     add_column :provider_goodstypes, :owner_type, :string
  end
end
