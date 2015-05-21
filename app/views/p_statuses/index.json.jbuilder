json.array!(@p_statuses) do |p_status|
  json.extract! p_status, :id, :name
  json.url p_status_url(p_status, format: :json)
end
