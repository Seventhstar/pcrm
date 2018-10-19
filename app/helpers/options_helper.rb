module OptionsHelper

  def inside_edit
    ['Work', 'Room']
  end

  def get_menu
    { options_users: ['users','roles','user_roles'],
      options_leads: ['statuses', 'channels', 'lead_sources', 'styles'],
      options_projects: ['project_statuses', 'project_types', 'elongation_types', 'contact_kinds'],
      options_costings: ['uoms', 'materials', "consumptions", "works", "work_types", "rooms"],
      options_payments: ['currencies', 'payment_types', 'payment_purposes'],
      options_providers: ['budgets', 'goodstypes', 'styles', 'p_statuses'],
      options_absences: ['holidays', 'absence_reasons', 'absence_targets', 'absence_shop_targets'],
      options_wiki: ['wiki_cats'] }
  end

  def class_name
    @item.class.name.underscore.pluralize
  end

  def t_items_list
    list = t(class_name)[2]
    "Список #{list}" 
  end

  def t_new_item
    item = t(class_name)[1]
    item = item[0] == '-' ? item[1..-1]: "Новый #{item}"
  end

  def get_active_option_page
    menu = get_menu
    v = menu.values.detect { |el| el.index(@page) }
    menu.values.index(v)
  end

end
