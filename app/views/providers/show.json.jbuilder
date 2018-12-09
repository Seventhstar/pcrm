if @provider
  json.extract! @provider, :id, :name, :manager, :phone, :komment, :address, :email, :url, :spec, :created_at, :updated_at
else
  json.array!(select_src(@providers)) do |provider|
    json.extract! provider, :value, :label
  end
end
