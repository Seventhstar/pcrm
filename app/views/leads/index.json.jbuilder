json.array!(@leads) do |lead|
  json.extract! lead, :id, :info, :fio, :footage, :phone, :email, :channel_id, :status_id, :user_id, :status_date
  json.url lead_url(lead, format: :json)
end
