json.array!(@items) do |item|
  json.extract! item, :id, :name
  json.url options_url(item, format: :json)
end
