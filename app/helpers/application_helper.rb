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


	def activeClassIfModel( model )
		if model && model == self.controller_name.classify
			"class=""active_li"""
		else ""

		end
	end

	def sortable_pil(column, title = nil)
		title ||= column.titleize
		css_class = column == sort_column ? "active #{sort_direction}" : nil
    #direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    direction = "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil) , {:class => css_class}
	end

  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end


	def set_only_active(active,title = nil)  
		css_class = active == "true" ? "active" : "passive"
		css_class.concat(" li-right")
		p_active = only_active != "true"
		link_to title, params.merge(:only_active => p_active) , {:class => css_class}
	end


	def avatar_url(user, size)
    	gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    		"http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end
end
