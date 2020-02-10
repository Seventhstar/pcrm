module OptionsHelper



  def has_view(classname, name)
    return lookup_context.find_all("#{classname}/_#{name}.html.erb").any? || 
            lookup_context.find_all("#{classname}/_#{name}.html.slim").any?
  end

  def inside_edit
    ['Work', 'Room']
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
    menu = @menu
    v = menu.values.detect { |el| el.index(@page) }
    menu.values.index(v)
  end

end
