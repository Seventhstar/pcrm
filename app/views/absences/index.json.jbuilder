json.array!(@absences) do |absence|
  json.extract! absence, :id, :user_id, :dt_from, :dt_to, :reason_id, :new_reason_id, :comment, :project_id
  json.url absence_url(absence, format: :json)
end
