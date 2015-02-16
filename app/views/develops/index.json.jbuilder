json.array!(@develops) do |develop|
  json.extract! develop, :id, :name, :coder, :boss
  json.url develop_url(develop, format: :json)
end
