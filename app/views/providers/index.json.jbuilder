json.array!(@providers) do |provider|
  json.extract! provider, :id, :name, :manager, :phone, :komment, :address, :email, :url, :spec
  json.url provider_url(provider, format: :json)
end
