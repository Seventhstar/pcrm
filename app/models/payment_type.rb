class PaymentType < ActiveRecord::Base
	has_many :receipts
end
