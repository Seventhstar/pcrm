json.array!(@wiki_records) do |wiki_record|
  json.extract! wiki_record, :id, :name, :description, :parent_id
  json.url wiki_record_url(wiki_record, format: :json)
end
