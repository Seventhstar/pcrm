json.array!(@payments) do |payment|
  json.extract! payment, :id, :project_id, :user_id, :whom_id, :whom_type, :payment_type_id, :payment_purpose_id, :date, :sum, :verified, :description
  json.url payment_url(payment, format: :json)
end
