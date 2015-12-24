json.array!(@absences) do |absence|
  json.extract! absence, :id, :user_id, :td_from, :td_to, :reason_id, :new_reason_id, :comment, :project_id
  json.url absence_url(absence, format: :json)
end
