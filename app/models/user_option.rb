class UserOption < ActiveRecord::Base
  has_many :users

  OPTIONS_MENU = {
    options_users: ['users', 'roles', 'user_roles'],
    options_leads: ['statuses', 'channels', 'lead_sources', 'styles', 'cities'],
    options_projects: ['project_statuses', 'project_stages', 'project_types', 'elongation_types', 'tarif_calc_types'],
    options_costings: ['costings_types', 'uoms', 'materials', "consumptions", "works", "work_types", "rooms"],
    options_payments: ['currencies', 'payment_types', 'payment_purposes'],
    options_providers: ['goodstypes', 'goods_priorities', 'delivery_times', 'positions', 'budgets', 'styles', 'p_statuses'],
    options_absences: ['holidays', 'working_days' ,'absence_reasons', 'absence_targets', 'absence_shop_targets'],
    options_wiki: ['wiki_cats']
  }.freeze 

  MANAGER_ALLOW = %w'users holidays working_days'

  def self.users_ids(id)
    id.nil? ? [] : self.where(option_id: id).pluck(:user_id)
  end


end
