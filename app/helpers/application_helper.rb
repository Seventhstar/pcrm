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

  # def td_actions(url, f)
  #   # <td><%= link_to 'Отмена', url, class: "sub btn_a btn_reset"%>
  #           # <%= f.button :submit, value: 'Сохранить', :class => 'sub btn_a ' %></td>
  #   content_tag :td do
  #     link_to 'Отмена', url, class: "sub btn_a btn_reset"
  #   end
  # end

  def month_year(date)
    "#{t date.try('strftime','%B')} #{date.try('strftime','%Y')}"
  end

  def f_time(date_time)
    date_time.try('strftime',"%H:%M")
  end

  def f_date(date_time)
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

  def tr_multi_select(f, field, source, label, params = {})
    attrs = {multiple: true,  class: "chosen-select", include_blank: 'None'}.merge(params)
    content_tag :tr do
      td_caption(label) + 
      content_tag(:td) do
        content_tag :div, class: "select_custom select" do
          f.collection_select field, source ,:id, :name, {}, attrs
        end
      end
    end
  end

  def td_text(f, field, params = {})
    cls = 'txt'
    cls += ' fullwidth' if f.class == String
    cls += ' datepicker' if params.has_key?(:date)

    attrs = {class: cls}
    attrs[:value] = params[:date] if params.has_key?(:date)

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

  def tr_text(f, field, label)
    content_tag :tr do
      td_caption(label) + td_text(f, field)
    end
  end

  def tr_chosen(id, collection, obj = nil, options = {})
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
      end
    elsif default.present?
        val = default.id
        label = default.name
    end
    h = val.present? ? {value: val, label: label} : []
    h = h.to_json.html_safe.to_s if safe
    h
  end

  def fill_vue_data(obj, data)
    if data[:boleans].present?
      data[:boleans].split(' ').each do |b|
        data[b] = obj[b].nil? ? false : obj[b]
      end
      data.delete(:boleans)
    end

    if data[:texts].present? 
      data[:texts].split(' ').each do |t|
        data[t] = obj[t].nil? ? '' : obj[t]
      end
      data.delete(:texts)
    end

    if data[:list_values].present? 
      data[:list_values].split(' ').each do |li| 
        data[li] = v_value(obj, li)
      end
      data.delete(:list_values)
    end

    if data[:lists].present?
      data[:lists].split(' ').each do |l|
        if l.index(':').nil?
          collection = eval("@#{l}")
        else
          la = l.split(':')
          collection = eval("#{la[1]}")
          l = la[0]
        end
        data[l] = select_src(collection) if collection.present?
      end
      data.delete(:lists)
    end

    return data.to_json.html_safe.to_s
  end

  def select_src(collection, attr_name = "name", safe = false)
    collection = collection.collect{|u| {label: u.try(attr_name), value: u.id}}
    collection = collection.to_json.html_safe.to_s if safe
    collection
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
    coll.insert(0,[nil_value,0,{class: 'def_value'}]) if nil_value != ''
    coll.insert(1,[options[:special_value],-1]) if !options[:special_value].nil?

    if !options[:selected].nil?
      sel = options[:selected]
    else
      is_attr = (obj.class != Integer && obj.class != String && !obj.nil?)
      sel = is_attr ? obj[id] : obj
    end 

    n = is_attr ? obj.model_name.singular+'['+ id.to_s+']' : id
    n = [add_name,'[',n,']',].join if !add_name.nil?

    def_cls = coll.count < 8 ? 'chosen' : 'schosen'
    cls       = options[:class].nil? ? def_cls : options[:class]
    cls = cls + ' '+ options[:add_class] if !options[:add_class].nil?
    cls = cls+" has-error" if is_attr && ( obj.errors[id].any? || obj.errors[id.to_s.gsub('_id','')].any? )
    l = label_tag options[:label]
    s = select_tag n, options_for_select(coll, selected: sel), class: cls, 'v-model' => v_model
    options[:label].nil? ? s : l+s
  end

  def sortable_pil(column, title = nil, default_dir = 'desc')

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
    content_tag :span, title, {class: css_class, sort: column, direction: direction }
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

    a = content_tag :div, "",{class: "sortArrow"}
    b = content_tag :span,title

    if not params.nil?
     params.delete("_")
   end

   link_to params.merge(sort2: column, dir2: direction, page: nil), {class: css_class} do
     b + a
   end
  end

  def only_actual_btn()
    txt = @only_actual == false ? 'Все' : "Актуальные"
    cls = @only_actual ? ' on only_actual' : ''
    active = @only_actual ?  'active' : ''
    a = content_tag :a, txt,{ class: "link_a left"+cls, off: "Все", on: "Актуальные"}
    b = content_tag :div, { class: 'scale'} do
      content_tag :div, '',{class:"handle "+ active}
    end
    cls = @only_actual ? ' toggled' : ''
    content_tag :div, {class: 'switcher_a'+ cls} do
      a+b
    end
  end

  def set_only_actual(actual,title = nil)
    css_class = actual == "false" ? "passive" : "active"
    css_class.concat(" only_actual li-right")
    p_active = only_actual == "false"
    p_title  = only_actual == "false" ? "Все" : "Актуальные"
    content_tag :span, p_title, {class: css_class}
  end

  def class_for_lead( lead )

    st_date  = lead.status_date? ? lead.status_date : DateTime.now
    actual = lead.status.actual if !lead.status.nil?
    if (!actual)
      "nonactual"
    elsif (st_date <= Date.today+1 )
      "hotlead"
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
    add_cls = options['modal'] ? ' update' : ''
    dd      = options['modal'] ? "modal" : ''

    submit_options = {class: "btn btn-default sub btn_a #{add_cls}"}
    submit_options[":disabled"] = options[:disabled] if options[:disabled]
    
    s = submit_tag 'Сохранить', submit_options
    c = link_to 'Отмена', back_url, class: "sub btn_a btn_reset", "data-dismiss": dd
    content_tag :div, class: "actns" do
      c+s
    end
  end

  def tool_icons(element, params = {})

    all_icons = {} #['edit','delete','show'] tag='span',subcount=nil
    params[:tag] ||= 'href'
    params[:icons] ||= 'edit,delete'
    icons = params[:icons].split(',').map { |e| e == 'edit' ? 'icon_edit' : e}

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

  def tooltip_if_big( info, length = 50 )
    if info.length >length
     tooltip( '   '+info[0..length] + ' ...', info)
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

  def simple_inputs(f, inputs)
    html = ''
    inputs.each do |el|
      html += content_tag :tr do 
        content_tag(:td, "#{t el}:", class: "caption") +
        content_tag(:td) do
          content_tag :div, class: "inp_w" do
            f.input(el, label: false)
          end
        end
      end
    end 
    html.html_safe
  end

end
