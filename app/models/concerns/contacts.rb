module Contacts
  extend ActiveSupport::Concern

  included do
    has_many :contacts,       as: :contactable, dependent: :destroy
    accepts_nested_attributes_for :contacts, allow_destroy: true, reject_if: :all_blank
  end
end
