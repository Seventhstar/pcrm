class Contact < ApplicationRecord
  belongs_to :contactable, polymorphic: true
  belongs_to :contact_kind
end
