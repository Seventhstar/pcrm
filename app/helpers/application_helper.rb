module ApplicationHelper

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
            "btn-danger"
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
    if (column == "status_date" && column != sort_column)
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

  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}

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

  def edit_delete(element,subcount = nil)
      content_tag :td,{:class=>"edit_delete"} do
	ed = link_to image_tag('edit.png'), edit_polymorphic_path(element) 
	subcount ||= 0
        if subcount>0 
  	   de = image_tag('delete-disabled.png')
	else
  	   de = link_to image_tag('delete.png'), element, method: :delete, data: { confirm: 'Действительно удалить?' }
	end 
	ed + de
      end
  end


end
