class RemoveContactKindFromContacts < ActiveRecord::Migration[5.1]
  def change
    remove_column :contacts, :contact_kind_id, :integer
  end
end
