module ApplicationHelper


  def attr_boolean?(item,attr)
    item.class.column_types[attr.to_s].class == ActiveRecord::Type::Boolean
  end

  def is_admin?
    current_user.admin? 
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

  def opt_page
     if self.controller_name =='leads' 
        'statuses'
     else
        'budgets'
     end
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

  #def chosen_src( id, collection, param_id, nil_value = 'Выберите...', special_value = '', p_name = 'name', order = 'name', cls = nil  )
  def chosen_src( id, collection, param_id = nil, options = {})  
    p_name    = options[:p_name].nil? ? 'name' : options[:p_name]
    order     = options[:order].nil? ? p_name : options[:order]
    nil_value = options[:nil_value].nil? ? 'Выберите...' : options[:nil_value]
    
    coll = collection.class.ancestors.include?(ActiveRecord::Relation) ? collection : collection
    coll = coll.collect{ |u| [u[p_name], u.id] }
    coll.insert(0,[nil_value,nil]) if nil_value != ''
    coll.insert(1,[options[:special_value],-1]) if !options[:special_value].nil?

    def_cls   = coll.count < 8 ? 'chosen' : 'schosen'
    cls       = options[:class].nil? ? def_cls : options[:class]
    l = label_tag options[:label]
    s = select_tag id, options_for_select(coll, :selected => param_id), class: cls
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
    content_tag :span, title,{ :class => css_class, :sort => column, :direction => direction } 
  end
  
  def sortable_th(column, title = nil)

    title ||= column.titleize
    css_class = column.to_s().include?(sort_2) ? "subsort current #{dir_2}" : "subsort"

    a = content_tag :div, "",{class: "sortArrow"}
    b = content_tag :span,title

    content_tag :span,{:class => css_class, :sort2 => column, :dir2 => dir_2} do
       b + a
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

    link_to params.merge(:sort2 => column, :dir2 => direction, :page => nil), {:class => css_class} do
       b + a
    end
  end

  def only_actual_btn()
    #<a href="#" class="link_a left on only_actual" off="Все" on="Актуальные">Актуальные</a>
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
    content_tag :span, p_title, {:class => css_class}
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

  def class_for_project (prj)
    actual = prj.pstatus_id == 3  ? "nonactual" : ""
    actual
  end



  def option_link( page,title )
    css_class = @page_data == page ? "active" : nil
    link_to title, '#',{:class =>"list-group-item #{css_class}", :controller => page}
  end

  def option_li( page,title )
    css_class = @page_data == page ? "active" : nil
    content_tag :li, {:class =>css_class } do
      link_to title, '#',{:class =>"list-group-item #{css_class}", :controller => page}
    end
  end


  def submit_cancel(back_url)
    # <%= link_to 'Отмена', absences_url, :class => "sub btn_a btn_reset"%><%= f.button :submit, value: 'Сохранить', :class => 'sub btn_a' %>
      s = submit_tag  'Сохранить', class: 'btn btn-default sub btn_a' 
      c = link_to 'Отмена', back_url, class: "sub btn_a btn_reset" 
      c+s
  end


  def td_tool_icons(element,str_icons='edit,delete',params = nil)
    
    all_icons = {} #['edit','delete','show'] tag='span',subcount=nil
    params ||= {}
    params[:tag] ||= 'href' 
    icons = str_icons.split(',')
    params[:subcount] ||= 0
    params[:add_cls] ||= ''
    dilable_cls = params[:subcount]>0 ? '_disabled' : ''
    if params[:tag] == 'span' 
      all_icons['edit'] = content_tag :span, "", {class: 'icon icon_edit', item_id: element.id}
      all_icons['delete'] = content_tag( :span,"",{class: ['icon icon_remove',dilable_cls,' ',params[:add_cls]].join, item_id: element.id})
    else
      all_icons['edit'] = link_to "", edit_polymorphic_path(element), class: "icon icon_edit"
      all_icons['show'] = link_to "", polymorphic_path(element), class: "icon icon_show", data: { modal: true }
      all_icons['delete'] = link_to "", element, method: :delete, data: { confirm: 'Действительно удалить?' }, class: "icon icon_remove " if params[:subcount]==0
      all_icons['delete'] = content_tag(:span,"",{class: 'icon icon_remove_disabled'}) if params[:subcount]>0
    end
    content_tag :td,{:class=>"edit_delete"} do
      icons.collect{ |i| all_icons[i] }.join.html_safe
    end

  end

  def tooltip_if_big( info, length = 50 )
      if info.length >length
         content_tag(:span,'   '+info[0..length]+' ...',{'data-toggle' =>"tooltip", 'data-placement' => "top", :title => info})
      else
         info
      end
  end

  def span_tooltip(info, full_info, cls, a, is_link = true )
    #content_tag( :span, info, {'data-toggle' =>"tooltip", 'data-placement' => "top", :title => full_info, :class => cls})''
    t_hash = {'data-toggle' =>"tooltip", 'data-placement' => "top", :title => full_info}
    if is_link
      b = link_to info.html_safe, [:edit, a], t_hash
    else
      b = content_tag :span, info.html_safe, t_hash
    end
    c = content_tag(:span,' ',{:class => cls})
    content_tag(:span,' ',{class: "numday"}) do 
      content_tag(:li,{class: cls}) do 
        content_tag(:span) do 
          b
        end
      end
    end
  end

  def ttip(info, full_info, cls, a )
    b = link_to info, [:edit, a], {'data-toggle' =>"tooltip", 'data-placement' => "top", :title => full_info}
  end

  def tooltip_str_from_hash(h)
    a = h.collect{ |k,v| [k,v].join(' ')}.join("\n")
    #puts a
  end

  def avatar_for( user )
     if user.present? && user.avatar.present?
        user.avatar.url.empty? ? image_tag('unknown.png') : image_tag(user.avatar) 
     else
        image_tag('unknown.png')
     end
  end

end
