class StartDateToLead < ActiveRecord::Migration
  def change
	add_column :leads, :start_date, :date
  end
end
