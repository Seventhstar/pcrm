json.array!(@leads_comments) do |leads_comment|
  json.extract! leads_comment, :id, :comment, :user_id
  json.url leads_comment_url(leads_comment, format: :json)
end
