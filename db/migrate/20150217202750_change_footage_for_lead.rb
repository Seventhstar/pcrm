class ChangeFootageForLead < ActiveRecord::Migration
  def change
   change_column :leads, :footage, 'integer USING CAST(column_name AS integer)'  
  end
end
