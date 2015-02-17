class ChangeFootageForLead < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :leads do |t|
        dir.up   { t.change :footage, :integer }
        dir.down { t.change :footage, :string }
      end
    end
  end
end
