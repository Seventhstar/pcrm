class PaymentPurpose < ActiveRecord::Base
  has_many :payments
end
