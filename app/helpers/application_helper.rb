module ApplicationHelper
  include CurrencyHelper
  
  def attr_boolean?(item, attr)
    item.column_for_attribute(attr.to_s).type == :boolean
  end
  
  def attr_date?(item, attr)
    item.column_for_attribute(attr.to_s).type == :date
  end

  def attr_date_or_bool?(item, attr)
    attr_boolean?(item, attr) || attr_date?(item, attr)
  end

  def is_admin?
    current_user.admin?
  end

  def is_author_of?(obj)
    current_user.author_of?(obj)
  end

  def is_manager?
    current_user.has_role?(:manager)
  end

  def contact_kind_src
    [["Телефон",1],["E-mail",2]]
  end

  def parents_count(item)
    links = item.class.name
                .constantize
                .reflect_on_all_associations(:has_many)
                .map(&:name)

    links.each do |l|
      if item.try(links[0]).count >0 
        return 1
      end
    end

    return 0
  end
  
  def month_year(date)
    "#{t date.try('strftime','%B')} #{date.try('strftime','%Y')}"
  end

  def format_date(date_time)
    date_time.try('strftime',"%d.%m.%Y")
  end


  def uncheked_tasks
    uncheked_tasks = Develop.where(dev_status_id: 2).size
    a = content_tag :span
    a = link_to uncheked_tasks, develops_path({develops_status_id: "2"}), { class: "uncheked_tasks", title: "Непроверенных задач" } if uncheked_tasks>0
    a
  end

  def develops_info
    if [1,5].include? current_user.id
      uncheked_tasks = Develop.where(dev_status_id: 2).size
      my_tasks       = current_user.develops.size      
      a = content_tag :span
      b = content_tag :span
      a = link_to uncheked_tasks, develops_path({develops_status_id: "2"}),  { class: "uncheked_tasks", title: "Непроверенных задач" } if uncheked_tasks>0
      b = link_to my_tasks, develops_path({develops_status_id: "1", develops_ic_user_id: current_user.id}), { class: "my_tasks", title: "Моих задач" } if my_tasks >0
      a + b
    end
  end

  def phone_format(phone)
    if phone
      if phone.length == 11
        ph = "#{phone[0]=='7' ? '+':''}#{phone[0]}(#{phone[1..3]}) #{phone[4..6]}-#{phone[7..8]}-#{phone[9..10]}"
      elsif phone.length == 7
        ph = "#{phone[4..6]}-#{phone[7..8]}-#{phone[9..10]}"
      else
        ph = phone
      end
      ph
    end
  end

  def date_ago( day )
    now = Date.today
    days = (now-day.to_date).to_i
    case days
    when 0
      'Сегодня'
    when 1
      'Вчера'
    else
      time_ago_in_words(day)  + ' назад ('+ day.try('strftime',"%d.%m.%Y") + ')'
    end
  end

  def allow_days_to_edit(date, days)
    if date.nil?
      return false
    end
    return date > (Date.today - eval("days.day"))
  end

  def calls_color
    if params[:controller] && params[:controller]=="leads" && params[:action]
      if params[:action]=="new"
       "red"
      elsif params[:action]=="edit"
       "orange"
      else
       "call"
      end
    else
      "call"
    end
  end

  def activeClassIfModel( model )
    if model && model == self.controller_name.classify
      "class=""active_li"""
    else ""
    end
  end

  def switch_active(show, label)
    active = show == @show_dev ? "active" : nil
    css_class = "btn #{active}"
    r = content_tag :input,'',{type: 'radio', value: show, name: 'show', id: show}
    t = content_tag :div, '',{class: "inp radio"} do
      r
    end
    content_tag :label, '',{class: css_class, show: show} do
      t + ' '+label
    end
  end

  def td_caption(label)
    content_tag(:td, class: "caption") do
      "#{label}:"
    end
  end

  def td_text(f, field, params = {})
    cls = 'txt'
    cls += ' fullwidth' if f.class == String
    cls += ' datepicker' if params.has_key?(:date)

    attrs = {class: cls}
    attrs[:value] = params[:date] if params.has_key?(:date)
    attrs[:placeholder] = params[:placeholder] if params.has_key?(:placeholder)

    content_tag(:td) do
      content_tag :div, class: "inp_w" do
        if f.class == String 
          text_field f, field, attrs
        else
          f.text_field field, attrs
        end
      end
    end
  end

  def tr_text(f, field, label, placeholder = nil)
    content_tag :tr do
      td_caption(label) + td_text(f, field, {placeholder: placeholder})
    end
  end

  def tr_multi_select(f, field, source, label, params = {})
    attrs = {multiple: true,  class: "chosen-select multi-select", include_blank: 'None'}.merge(params)
    content_tag :tr do
      td_caption(label) + 
      content_tag(:td) do
        content_tag :div, class: "select_custom select" do
          f.collection_select field, source, :id, :name, {}, attrs
          # f.grouped_collection_select field, source, :id, :name, {}, attrs
        end
      end
    end
  end

  def tr_chosen(id, collection, obj = nil, options)
    label = options.class == String ? options : options[:caption]
    options = {} if options.class == String
    content_tag :tr do
      content_tag(:td, class: "caption") do
        "#{label}:"
      end + 
      content_tag(:td) do
        content_tag :div, class: "inp_w" do
          chosen_src(id, collection, obj, options)
        end
      end
    end
  end

  def v_value(obj, name, attr_name = nil, default = nil, safe = false)
    attr_name ||= "name"
    if !obj.nil? && obj.id? 
      if !obj["#{name}_id"].nil? && obj["#{name}_id"]>0
        val = obj["#{name}_id"]
        label = obj.try("#{name}_#{attr_name}")
        label = obj&.try(name)&.try(attr_name) if label.nil?
      end
    elsif default.present?
      if default.class == Hash then
        val   = default[:id]
        label = default[:name]
      elsif default.class == String || default.class == Integer
        val   = default
        return val
      else
        val   = default.id
        label = default.name
      end
    end
    # h = val.present? ? {value: val, label: label} : []
    h = {}
    h[:value] = val if val.present? 
    h[:label] = label if label.present? 
    puts "#{name} - #{h}"
    h = h.to_json.html_safe.to_s if safe
    h
  end

  def fill_vue_data(obj, data, where = nil)
     # kjl k
    if data[:required_list].present?
        data[:required] = []
        data[:requiredTranslated] = []

        data[:required_list].split(' ').each do |r|
          data[:required] << r
          data[:requiredTranslated] << t(r)
        end
    end

    if data[:booleans].present?
      data[:booleans].split(' ').each do |b|
        # puts "booleans", b, obj[b].nil?
        data[b] = obj[b].nil? ? eval("@#{b}") : obj[b]
      end
      data.delete(:booleans)
    end

    if data[:texts].present? 
      data[:texts].split(' ').each do |t|
        data[t] = eval("@#{t}")
        # puts data[t], t
        data[t] = obj.nil? || obj[t].nil? ? '' : obj[t] if data[t].nil?
      end
      data.delete(:texts)
    end

    if data[:lists].present? # collection_name[:source_name][+field1,field2...]
      # ewjnek
      data[:lists].split(' ').each do |l|
        fields = nil
        raw = false
        if l.index('+').present? 
          lf = l.split('+')
          fields = lf[1]
          l = lf[0]
        end
        if l.index(':').nil?
          collection = eval("@#{l}")
        else
          la = l.split(':')
          if la[1].include?('raw')
            raw = true
            la[1].sub! 'raw', ''
          end
          collection = eval("#{la[1]}")
          l = la[0]
        end
        if collection.present? 
          if raw 
            data[l] = collection 
          else
            # puts "1. data[:lists] #{data[:lists]}, l: #{l}", "collection: #{collection}"
            data[l] = select_src(collection, "name", false, fields) 
            # puts "2. l #{l} collection: #{collection}", "data[l] #{data[l]}"
          end
        else
          data[l] = []
        end
      end
      data.delete(:lists)
    end

    if data[:list_values].present? 
      data[:list_values].split(' ').each do |li| 
        v = v_value(nil, nil, nil, eval("@#{li}"))        
        v = v_value(obj, li) if !v.present?
        if v.class == Integer
          v = data[li.pluralize].select {|a| a[:value] == v }
          v = v[0] if v.length
          # wkfhjek
        end
        # puts "li #{li} - v #{v}"
        data[li] = v
        # puts "data #{data}"
      end
      data.delete(:list_values)
    end

    return data.to_json.html_safe.to_s
  end

  def select_src(collection, attr_name = "name", safe = false, fields_str = nil)
    # puts collection.class
    if fields_str.nil? 
      collection = collection.collect{|u| 
        case u.class.to_s
          when "Hash"
            {label: u[attr_name.to_sym], value: u[:id]} if u[attr_name.to_sym].present? 
          when "Array"
          else
            {label: u.try(attr_name), value: u.id} if u.try(attr_name).present? 
        end
      }.compact
      # puts "collection2: #{collection}"
    else
      fields = fields_str.split(',')
      collection = collection.collect{|u| 
        c = {label: u.try(attr_name), value: u.id}
        fields.each {
          |f| c[f] = u.try(f)
        }
        c
      }
    end
    collection = collection.to_json.html_safe.to_s if safe
    collection
  end

  def get_attribute(obj, el)
    r = obj[el]
    r = obj.try(el.to_s + '_name') if r.nil?
    r
  end

  def chosen_src(id, collection, obj = nil, options = {})

    p_name    = options[:p_name].nil? ? 'name' : options[:p_name]
    order     = options[:order].nil? ? p_name : options[:order]
    nil_value = options[:nil_value].nil? ? 'Выберите...' : options[:nil_value]
    add_name  = options[:add_name]
    v_model   = options[:v_model]

    coll = collection.class.ancestors.include?(ActiveRecord::Relation) ? collection : collection
    if coll.nil?  
      return
    end

    coll = coll.collect{ |u| [u[p_name], u.id] } if coll.class.name != 'Array'
    coll.insert(0, [nil_value, 0, {class: 'def_value'}]) if nil_value != ''
    coll.insert(1, [options[:special_value], -1]) if !options[:special_value].nil?

    if !options[:selected].nil?
      sel = options[:selected]
    else
      is_attr = (obj.class != Integer && obj.class != String && !obj.nil?)
      sel = is_attr ? obj[id] : obj
    end 

    n = is_attr ? obj.model_name.singular+'['+ id.to_s+']' : id
    n = [add_name,'[',n,']',].join if !add_name.nil?

    def_cls = coll.count < 8 ? 'chosen' : 'schosen'
    cls     = options[:class].nil? ? def_cls : options[:class]
    cls = cls + ' '+ options[:add_class] if !options[:add_class].nil?
    cls = cls + " has-error" if is_attr && ( obj.errors[id].any? || obj.errors[id.to_s.gsub('_id','')].any? )
    l = label_tag options[:label]

    select_params = {class: cls, 'v-model' => v_model}
    select_params[:disabled] = options[:disabled] if options[:disabled].present?
    select_params[:readonly] = options[:readonly] if options[:readonly].present?
    select_params[:tabindex] = options[:tabindex] if options[:tabindex].present?

    s = select_tag n, options_for_select(coll, selected: sel), select_params
    options[:label].nil? ? s : l+s
  end

  def sortable_pil(column, title = nil, default_dir = 'desc', fn = nil)

    title ||= column.titleize
    sort_col = @sort_column == 'month' ?  "start_date": @sort_column
    css_class = column == sort_col ? "active #{sort_direction}" : ""
    css_class.concat(" sort-span")

    direction = column == @sort_column && sort_direction
    if (column == "month" && column != @sort_column)
      direction = "desc"
    end
    if (direction == false)
      direction = default_dir
    end

    css_class.concat(" vue_sort") if !fn.nil?

    tags = {class: css_class, sort: column, direction: direction }
    tags['v-on:click'] = fn if !fn.nil?
    content_tag :span, title, tags
  end

  def sortable_th(column, title = nil, nosort = false)
    title ||= column.titleize
    css_class = column.to_s().include?(sort_2) ? "subsort current #{dir_2}" : "subsort"

    a = content_tag :div, "",{class: "sortArrow"}
    b = content_tag :span, title.html_safe

    if nosort 
      title
    else
      content_tag :span, {class: css_class, sort2: column, dir2: dir_2} do
        b + a
      end
    end
  end

  def sortable(column, title = nil)

    title ||= column.titleize
    css_class = column.to_s() == sort_2 ? "current #{dir_2}" : nil

    direction = column.to_s.include?(sort_2.to_s) && dir_2.include?("asc") ? "desc" : "asc"
    hdir = column == sort_2 && direction == "asc" ? "desc" : "asc"

    a = content_tag :div, "", {class: "sortArrow"}
    b = content_tag :span, title

    if not params.nil?
     params.delete("_")
   end

   link_to params.merge(sort2: column, dir2: direction, page: nil), {class: css_class} do
     b + a
   end
  end

  def only_actual_btn(filter = "only_actual", actual = "Актуальные")
    @only_actual = params[:only_actual].nil? ? true : params[:only_actual] == 'true'
    # puts "@only_actual #{@only_actual}, #{params[only_actual]}"

    var = eval("@#{filter}")
    txt = var == false ? 'Все' : actual
    cls = var ? " on #{filter}" : ''
    active = var ?  'active' : ''
    a = content_tag :a, txt, {class: "link_a left" + cls, off: "Все", on: actual}
    b = content_tag :div, { class: 'scale'} do
      content_tag :div, '', {class: "handle "+ active}
    end
    cls = var ? ' toggled' : ''
    content_tag :div, {class: 'switcher_a'+ cls} do
      a + b
    end
  end

  def set_only_actual(actual, title = nil)
    css_class = actual == "false" ? "passive" : "active"
    css_class.concat(" only_actual li-right")
    p_active = only_actual == "false"
    p_title  = only_actual == "false" ? "Все" : "Актуальные"
    content_tag :span, p_title, {class: css_class}
  end

  def class_for_lead( lead )

    st_date  = lead.status_date? ? lead.status_date : DateTime.now
    actual = lead.status.actual if !lead.status.nil?
    
    if (st_date < Date.today.beginning_of_day )
      "hotlead"
    elsif st_date < (Date.today.beginning_of_day+1.day)
      "goodlead"
    elsif (!actual)
      "nonactual"
    end

  end

  def total_info(t_array)
    s = ''
    currency = ['Руб. ','$','€']
    i = 1
    currency.each do |c|
      tsum = t_array[i]
      s = s + ' | ' if s.length >0 && tsum>0
      s = s + c + tsum.to_sum if tsum>0
      i = i + 1 
    end
    s
  end

  def option_link(page, title)
    css_class = @page_data == page ? "active" : nil
    link_to title, '#', {class: "list-group-item #{css_class}", controller: page}
  end

  def option_li(page, title)
    css_class = @page == page ? "active" : nil
    content_tag :li, {class: css_class } do
      link_to title, '#', {class: "list-group-item #{css_class}", controller: page}
    end
  end

  def td_add_sub_send(action, prm)
    content_tag :td do
      content_tag :span, {class: 'sub btn_a', id: "btn-sub-send", action: "/#{action}/", prm: prm} do
        'Добавить'
      end
    end
  end

  def tr_submit_cancel(back_url, options = {})
    content_tag :tr do
      content_tag(:td, '', class: "caption") + 
      content_tag(:td) do
        submit_cancel(back_url, options) 
      end
    end
  end

  def submit_cancel(back_url, options = {})
    is_modal = options['modal'] || options[:modal]
    add_cls = is_modal ? ' update' : ''
    dd      = is_modal ? "modal" : ''
    
    submit_options = {}
    cls = "btn sub btn_a #{add_cls}"

    if options[:classValid] 
      submit_options[':class'] = "[{disabled: #{options[:classValid]}}, '#{cls}']" # ':class' for vue
    else
      submit_options['class'] = cls
    end

    submit_options[':data-original-title'] = options[:tip] if options[:tip]
    # вернуть если нужен tooltip 
    submit_options["v-on:click"] = options[:click] if options[:click]
    
    s = submit_tag 'Сохранить', submit_options
    if is_modal 
      c = button_tag "Отмена", type: "button", class: "text btn_a btn_reset", "data-dismiss": "modal"         
    else
      c = link_to 'Отмена', back_url, class: "sub btn_a btn_reset"
    end

    content_tag :div, class: "actns" do
      c + s
    end
  end

  def form_head(object, title)
    head = "#{controller.action_name == 'edit' ? 'Редактирование' : 'Новый'} #{title}"
    t = content_tag :span, head
    lnk = link_to "", object, method: :delete, data: { confirm: 'Действительно удалить?' }, class: "icon icon_remove right"

    content_tag :div, {class: 'hl hl_a bd'} do
      is_manager? ? t + lnk : t 
    end
  end

  def tool_icons(element, params = {})

    all_icons = {} #['edit','delete','show'] tag='span',subcount=nil
    params[:tag] ||= 'href'
    params[:icons] ||= 'edit, delete'
    icons = params[:icons].split(',').map { |e| e == 'edit' ? 'icon_edit' : e.strip}

    params[:subcount] ||= 0
    params[:class] ||= ''
    params[:content_class] ||= ''
    params[:content_tag] ||= :td
    add_cls = ' ' + params[:add_class] ||= ''
    content = params[:content_tag]
    dilable_cls = params[:subcount]>0 ? '_disabled' : ''
    
    modal     = params[:modal] ||= false
    datap     = modal ? { modal: true } : {}
    data_del  = modal ? { confirm: 'Действительно удалить?' } : { confirm: 'Действительно удалить?' }
    i_edit = (icons & ['icon_edit','inline_edit','modal_edit','basket']).first

    style = ""
    style = 'width: ' + params[:width] if params[:width] 

    if params[:tag] == 'span'

      all_icons[i_edit] = content_tag :span, "", {class: "icon #{i_edit}", item_id: element.id} if !i_edit.nil?
      all_icons['delete'] = content_tag( :span, "",{class: ['icon icon_remove',dilable_cls,' ',params[:class]].join, item_id: params[:subcount]>0 ? '' : element.id})
    else
      all_icons[i_edit] = link_to "", edit_polymorphic_path(element), class: "icon "+i_edit + params[:class], data: datap if !i_edit.nil?
      all_icons['show'] = link_to "", polymorphic_path(element), class: "icon icon_show", data: { modal: true }
      all_icons['delete'] = link_to "", polymorphic_url(element), 
      method: :delete, data: data_del, remote: modal,
      class: "icon icon_remove " + params[:class] if params[:subcount]==0
        all_icons['delete'] = content_tag(:span,"",{class: 'icon icon_remove_disabled'}) if params[:subcount]>0
    end

    content_tag content,{class: "edit_delete #{add_cls} #{params[:content_class]}", rowspan: params[:rowspan], style: style} do
      icons.collect{ |i| all_icons[i] }.join.html_safe
    end
  end

  def tooltip( s_info, info, safe = false )
    params = ""
    tt = safe ? info.html_safe : info
    params = {'data-toggle': "tooltip", 'data-placement': "top", title: tt} if tt.present?
    content_tag(:span, s_info, params)
  end

  def tooltip_if_big( info, length = 50)
    if info.length > length
      tooltip( '   ' + info[0..length] + ' ...', info)
    else
      info
    end
  end

  def span_tooltip(info, full_info, cls, a, is_link = true )
    t_hash = {'data-toggle' => "tooltip", 'data-placement' => "top", title: full_info}
    if is_link
      b = link_to info.html_safe, [:edit, a], t_hash
    else
      b = content_tag :span, info.html_safe, t_hash
    end
    c = content_tag(:span, ' ', {class: cls})
    content_tag(:span, ' ', {class: "numday"}) do
      content_tag(:li, {class: cls}) do
        content_tag(:span) do
          b
        end
      end
    end
  end

  def ttip(info, full_info, cls, a )
    b = link_to info, [:edit, a], {'data-toggle' =>"tooltip", 'data-placement' => "top", title: full_info}
  end

  def tooltip_str_from_hash(h)
    a = h.collect{ |k,v| [k,v].join(' ') if v.present?}.join("\n")
  end

  def avatar_for( user )
    if user.present? && user.avatar.present?
      user.avatar.url.empty? ? image_tag('unknown.png') : image_tag(user.avatar)
    else
      image_tag('unknown.png')
    end
  end

  def vue_multi_select(f, field, source, label, params = {})
    attrs = {multiple: true,  class: "chosen-select multi-select", include_blank: 'None'}.merge(params)
    content_tag(:div, "#{label}:", class: "caption") + 
    content_tag(:div, class: "select_custom select") do
      f.collection_select field, source, :id, :name, {}, attrs
    end    
  end

  def vue_table_text(f, field, label, placeholder = '')
    content_tag(:div, "#{label}:", class: "caption") + 
    content_tag(:div, class: "inp_w") do
        f.input(field, label: false, placeholder: placeholder)
    end 
  end

  def vue_table_chosen(id, collection, obj = nil, options)
    label = options.class == String ? options : options[:caption]
    options = {} if options.class == String
    content_tag(:div, "#{label}:", class: "caption") +
    content_tag(:div, class: "inp_w") do
      chosen_src(id, collection, obj, options)
    end
  end

  def vue_submit_cancel(back_url, options = {})

      content_tag(:div, '', class: "caption") + 
      content_tag(:div) do
        submit_cancel(back_url, options) 
      end
    
  end



  def simple_inputs(f, inputs, tag = :div)
    html = ''
    inputs.each do |el|
      html += content_tag :tr do 
        content_tag(tag, "#{t el}:", class: "caption") +
        content_tag(tag) do
          content_tag :div, class: "inp_w" do
            f.input(el, label: false)
          end
        end
      end
    end 
    html.html_safe
  end

end
