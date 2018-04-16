class Contact < ApplicationRecord
  belongs_to :contactable, polymorphic: true
  belongs_to :contact_kind

  def contact_kind_name
    self.contact_kind.try(:name)
  end  
end
