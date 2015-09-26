json.array!(@receipts) do |receipt|
  json.extract! receipt, :id, :project_id, :user_id, :provider_id, :payment_type_id, :date, :sum, :description
  json.url receipt_url(receipt, format: :json)
end
