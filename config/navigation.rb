# -*- coding: utf-8 -*-
SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'selected active'
  navigation.active_leaf_class = 'active'
  # navigation.autogenerate_item_ids = false
  navigation.items do |primary|
    search_class = "search_save"
    leads_class = request.url == root_url ? "selected active" : ""

    # puts "params[:search] #{params[:search]}"
    s_params = {}
    s_params[:search] = params[:search] if params[:search].present?

    primary.item :leads, 'Лиды', leads_path(s_params), html: {class: "#{search_class} #{leads_class}"} 
    primary.item :tarifs, 'Тарифы', tarifs_path, if: -> { current_user.has_role?(:manager) }
      
    primary.item :projects, 'Проекты', projects_path(s_params), html: {class: search_class}, if: -> { current_user.has_role?(:designer) } do |sub_nav|
      sub_nav.item :projects, 'Проекты', projects_path
      sub_nav.item :clients, 'Клиенты', clients_path  
    end
     
    primary.item :providers, 'Поставщики', providers_path do |sub_nav|
      sub_nav.item :projects, 'Поставщики', providers_path(s_params), html: {class: search_class}
      sub_nav.item :providers_groups, 'Группы поставщиков', providers_groups_path  
    end


    primary.item :providers, 'Сметы', costings_path
    
    primary.item :receipts, 'Деньги', '/receipts/', if: -> { current_user.admin? } do |sub_nav|
      sub_nav.item :receipts, 'Приходы', receipts_path
      sub_nav.item :payments, 'Расходы', payments_path  
    end

    primary.item :providers, 'Заказы', project_goods_path

    primary.item :absence, 'Календарь', absences_path

    primary.item :wiki_records, 'База знаний', wiki_records_path do |sub_nav|
      sub_nav.item :receipts, 'Знания', wiki_records_path
      sub_nav.item :payments, 'Файлы', wiki_files_path  
    end

    if current_user.admin? 
      primary.item :options,  content_tag(:span), options_path, html: {class: 'li-right options', title: 'Настройки'}
      primary.item :develops, content_tag(:span), develops_path, html: {class: 'li-right develops',title: 'Разработка', } 
      primary.item :charts1,  content_tag(:span), statistics_path, html: {class: 'li-right', title: 'Статистика'} 
      primary.item :history,  content_tag(:span), history_index_path, html: {class: 'li-right', title: 'История'} 
    end

    primary.dom_class = 'nav'
  end
end

