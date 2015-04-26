json.array!(@dev_projects) do |dev_project|
  json.extract! dev_project, :id, :name, :priority_id
  json.url dev_project_url(dev_project, format: :json)
end
