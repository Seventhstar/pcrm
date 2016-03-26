class PaymentType < ActiveRecord::Base
	has_many :receipts
	has_many :payments
end
