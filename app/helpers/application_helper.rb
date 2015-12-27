module ApplicationHelper


  def attr_boolean?(item,attr)
    item.class.column_types[attr.to_s].class == ActiveRecord::Type::Boolean
  end

  def is_admin?
    current_user.admin? 
  end
  
  def opt_page
     if self.controller_name =='leads' 
        'statuses'
     else
        'budgets'
     end
  end

  def will_paginate(collection_or_options = nil, options = {})
    if collection_or_options.is_a? Hash
      options, collection_or_options = collection_or_options, nil
    end
    unless options[:renderer]
      options = options.merge :renderer => BootstrapPagination::Rails
    end
    super *[collection_or_options, options].compact
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

  def class_for_abs( absence )
      
      absence.reason_id == 1 ? "hot" : ""
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

  def td_tool_icons(element,str_icons='edit,delete',tag='span',subcount=nil)
    
    all_icons = {} #['edit','delete','show']
    icons = str_icons.split(',')
    subcount ||= 0
    dilable_cls = subcount>0 ? '_disabled' : ''
    if tag == 'span' 
      all_icons['edit'] = content_tag :span, "", {class: 'icon icon_edit', item_id: element.id}
      all_icons['delete'] = content_tag( :span,"",{class: 'icon icon_remove'.concat(dilable_cls), item_id: element.id})
    else
      all_icons['edit'] = link_to "", edit_polymorphic_path(element), class: "icon icon_edit"
      all_icons['show'] = link_to "", polymorphic_path(element), class: "icon icon_show", data: { modal: true }
      all_icons['delete'] = link_to "", element, method: :delete, data: { confirm: 'Действительно удалить?' }, class: "icon icon_remove " if subcount==0
      all_icons['delete'] = content_tag(:span,"",{class: 'icon icon_remove_disabled'}) if subcount>0
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

  def avatar_for( user )
     if user.present? && user.avatar.present?
        user.avatar.url.empty? ? image_tag('unknown.png') : image_tag(user.avatar) 
     else
        image_tag('unknown.png')
     end
  end

end
