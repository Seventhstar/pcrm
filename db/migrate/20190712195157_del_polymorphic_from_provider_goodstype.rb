class DelPolymorphicFromProviderGoodstype < ActiveRecord::Migration[5.1]
  def change
     rename_column :provider_goodstypes, :owner_id, :provider_id
     remove_column :provider_goodstypes, :owner_type
  end
end
