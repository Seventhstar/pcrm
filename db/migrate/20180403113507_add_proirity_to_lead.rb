class AddProirityToLead < ActiveRecord::Migration[5.1]
  def change
    add_reference :leads, :priority, foreign_key: true
  end
end
