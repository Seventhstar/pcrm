json.array!(@goodstypes) do |goodstype|
  json.extract! goodstype, :id, :name
  json.url goodstype_url(goodstype, format: :json)
end
