class StartDateToLead < ActiveRecord::Migration[4.2]
  def change
	add_column :leads, :start_date, :date
  end
end
