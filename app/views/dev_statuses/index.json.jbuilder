json.array!(@dev_statuses) do |dev_status|
  json.extract! dev_status, :id, :name, :dev_status_id
  json.url dev_project_url(dev_status, format: :json)
end
