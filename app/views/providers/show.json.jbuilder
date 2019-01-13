if @provider
  json.extract! @provider, :id, :name, :manager, :phone, :komment, :address, :email, :url, :spec, :created_at, :updated_at
else
  json.array!(@providers.map{|p| {value: p.id, label: p.name, mark: p.p_status_id == 5}}) do |provider|
    json.extract! provider, :value, :label, :mark
  end
end
