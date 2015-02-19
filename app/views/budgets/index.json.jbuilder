json.array!(@budgets) do |budget|
  json.extract! budget, :id, :name
  json.url budget_url(budget, format: :json)
end
