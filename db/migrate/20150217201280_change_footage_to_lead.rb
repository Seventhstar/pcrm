class ChangeFootageToLead < ActiveRecord::Migration
  def change
     change_column :leads, :footage, 'integer USING CAST(footage AS integer)'
  end
end
