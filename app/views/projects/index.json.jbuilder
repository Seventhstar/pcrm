json.array!(@projects) do |project|
  json.extract! project, :id, :client_id, :address, :owner_id, :executor_id, :designer_id, :project_type_id, :date_start, :date_end_plan, :date_end_real, :number, :footage, :footage2, :footage_real, :footage2_real, :style_id, :sum, :sum_real, :price_m, :price_2, :price_real_m, :price_real_2, :month_in_gift, :act, :delay_days
  json.url project_url(project, format: :json)
end
