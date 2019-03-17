class AddLeadToProject < ActiveRecord::Migration[5.1]
  def change
    add_reference :projects, :lead, foreign_key: true
  end
end
