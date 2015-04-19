module ApplicationHelper
  
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
            "orange"
	 elsif params[:action]=="edit"
	    "btn-warning"
         else
	    "btn-success"
         end
      else
         "btn-success"
      end
  end

  def activeClassIfModel( model )
    if model && model == self.controller_name.classify
	"class=""active_li"""
    else ""
    end
  end

  def sortable_pil(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "active #{sort_direction}" : ""
    css_class.concat(" sort-span")

    #direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    direction = column == sort_column && sort_direction
    #puts direction
    #if (column == "status_date" && column != sort_column)
    if (column == "month" && column != sort_column)
      direction = "desc"
    end  

    add_text = ""
    #if column == sort_column 
    #   add_text = sort_direction == "asc" ? " ▲" : " ▼"
    #end
    #direction = "asc"
    #link_to title, params.merge(:sort => column, :direction => direction, :page => nil) , {:class => css_class}
    content_tag :span, title + add_text,{ :class => css_class, :sort => column, :direction => direction } 
  end


  
  def sortable_th(column, title = nil)

    title ||= column.titleize
    css_class = column.to_s().include?(sort_2) ? "subsort current #{dir_2}" : "subsort"

    direction = column.to_s.include?(sort_2.to_s) && dir_2.include?("asc") ? "desc" : "asc"
    hdir = column == sort_2 && direction == "asc" ? "desc" : "asc"

    a = content_tag :div, "",{class: "sortArrow"}
    b = content_tag :span,title

    if not params.nil?
       params.delete("_")
    end

    puts "params: "
    puts sort_2
    puts dir_2
    puts css_class 
	
	
	#content_tag :span,{:class => css_class, :url => params.merge(:sort2 => column, :dir2 => direction, :page => nil)} do
	content_tag :span,{:class => css_class, :sort2 => column, :dir2 => dir_2} do
    #link_to params.merge(:sort2 => column, :dir2 => direction, :page => nil), {:class => css_class} do
       b + a
    end  

  end
  
  def sortable(column, title = nil)

    #flash[:success] = column.to_s() +' '+ sort_column.to_s()
    title ||= column.titleize
    css_class = column.to_s() == sort_2 ? "current #{dir_2}" : nil

    direction = column.to_s.include?(sort_2.to_s) && dir_2.include?("asc") ? "desc" : "asc"
    hdir = column == sort_2 && direction == "asc" ? "desc" : "asc"

	puts "direction: " + direction
    puts "dir_2: "+ dir_2.class.to_s + " " +dir_2+" " + "desc".class.to_s + " desc"
    puts "res" + dir_2.include?("desc").to_s
    puts column
    puts column.to_s.include?(sort_2.to_s)
    puts sort_2

    #s

    a = content_tag :div, "",{class: "sortArrow"}
    b = content_tag :span,title

    if not params.nil?
       params.delete("_")
    end

    link_to params.merge(:sort2 => column, :dir2 => direction, :page => nil), {:class => css_class} do
       b + a
    end
    #link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class} 
  end


  def switchable(show, title)
      css_class = show == show_dev ? "focus" : nil
      #input title, {:class => "btn btn-default #{css_class}", :type => "button", :id => show}
      button_tag title, {:class => "btn btn-default #{css_class}", :type => "button", :id => show}
      #<button type="button" class="btn btn-default #{css_class}">title</button>
      #link_to title, params.merge(:show => show), {:class => "btn btn-default", :role => "group", :autofocus => css_class}
  end

  def switch_active(show)

    active = show == show_dev ? "active" : nil
    css_class = "btn #{active}" 
  end

  def set_only_actual(actual,title = nil)  
		css_class = actual == "false" ? "passive" : "active"
		css_class.concat(" only_actual li-right")
		p_active = only_actual == "false"
    p_title  = only_actual == "false" ? "Все" : "Актуальные"
		#link_to p_title, params.merge(:only_actual => p_active) , {:class => css_class}
    #content_tag :span, p_title, {:class => css_class, :pamams => params.merge(:only_actual => p_active)}
    content_tag :span, p_title, {:class => css_class}
    #<span class="btn btn-warning btn-sm only_actual" id="btn-send"> </span>
  end

  def class_for_lead( lead )

    st_date  = lead.status_date? ? lead.status_date : DateTime.now
    if (!lead.status.actual)
      "nonactual"
    elsif (st_date <= Date.today+1 )
      "hotlead"
      #(lead.status_date > Now().)
    end
    
  end

  def avatar_url(user, size)
    	gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    		"http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
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


  def edit_delete(element,subcount = nil)
      content_tag :td,{:class=>"edit_delete"} do
	ed = link_to "", edit_polymorphic_path(element), :class=>"icon icon_edit" 
	subcount ||= 0
        if subcount>0 
  	   de = content_tag("span","",{:class=>'icon icon_remove disabled'})
	else
  	   de = link_to "", element, method: :delete, data: { confirm: 'Действительно удалить?' }, :class=>"icon icon_remove" 
	end 
	ed + de
      end
  end


end
