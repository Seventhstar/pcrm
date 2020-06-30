module VueHelper
  def for_vue(data, methods = [], except = [])
    except = [:created_at, :updated_at] if except.empty?

    data.to_json(except: except, methods: methods).html_safe
  end

  def string_to_array(string)
    if string.class == Array 
      return string
    elsif string.include?(' ')
      return string.split(' ').map(&:strip)
    elsif string.include?(',')
      return string.split(',').map(&:strip)
    end
    string.split(' ')
  end

  def add_vue_index_fields(data)
    data[:groupBy] = 'month'
    data[:reverse] = true
    data[:currentIndex] = -1
    data[:currentMonth] = -1
    data[:confirmModal] = false
    data[:groupName] = 'month'
    data[:groupHeaders] = []
    data[:menu_items] = [] if data[:menu_items].nil?
    data[:filterItems] = [] if data[:filterItems].nil?
    data[:showTotal] = false
    data[:readyToChange] = false
    data[:filter] = []
    data[:grouped] = []
    data[:filteredData] = []
    data[:list_values] = []
    data[:lists] = 'mainList:raw@json_data'
    data
  end


  def fill_vue_data(obj, data, where = nil, to_include = nil)
    if controller.action_name == "index" 
      data[:controller] = controller.controller_name if !data[:controller].present? 
    end

    if to_include.present? && to_include.include?('vue_index')
      data = add_vue_index_fields(data)
    end

    if data[:menu_items].present?
      new_array = []
      string_to_array(data[:menu_items]).each do |mi|
        m = mi.split(':')
        new_array.push({label: m[0], link: m[1]} )
      end
      data[:menu_items] = new_array
    end

    if data[:columns].present? && [String, Array].include?(data[:columns].class)
      new_array = []
      string_to_array(data[:columns]).each do |col| 
        if col.class == Array
          name  = col[0]
          label = col[1]
        else
          if col.include?(':')
            a = col.split(':')
            name = a[0]
            label = a[1].gsub('_', ' ')
          else
            name = col
            label = t name
          end
        end

        name = name[0..-4] if name.end_with?("_id") 
        new_array.push([name, label])
      end
      data[:columns] = new_array
    end

    if data[:groupBys].present?
      data[:lists] = !data[:lists].present? ? [] : string_to_array(data[:lists])
      data[:translated] = {} if !data[:translated].present? 
      data[:list_values] = [] if !data[:list_values].present?
      data[:list_values] = data[:list_values].push('groupBy').compact
      # puts "data[:list_values] #{data[:list_values]}"
      new_array = []
      string_to_array(data[:groupBys]).each do |fi|
        if fi.include?(':')
          f = fi.split(':')
          val = f[0]
          label = f[1].gsub('_', ' ')
        else
          val = fi
          label = t(fi)
        end
        data[:lists].push(val.classify.pluralize.downcase)
        data[:translated][val] = label 
        new_array.push({label: label, value: val})
      end      
      data[:groupBys] = new_array
    end

    if data[:filterItems].present?
      data[:lists] = !data[:lists].present? ? [] : string_to_array(data[:lists])
      data[:translated] = {} if !data[:translated].present? 
      data[:list_values] = [] if !data[:list_values].present?

      string_to_array(data[:filterItems]).each do |fi|
        data[:list_values] << fi
        data[:lists].push(fi.classify.pluralize.downcase)
        data[:translated][fi] = t(fi+'_id')
      end
      @filterItems = data[:filterItems]
    end

    if data[:required_list].present?
      data[:required] = []
      data[:requiredTranslated] = []

      string_to_array(data[:required_list]).each do |r|
        data[:required] << r
        data[:requiredTranslated] << t(r)
      end
    end

    if data[:booleans].present?
      string_to_array(data[:booleans]).each do |b|
        # puts "booleans", b, obj[b].nil?
        data[b] = obj[b].nil? ? eval("@#{b}") : obj[b]
      end
      data.delete(:booleans)
    end

    if data[:texts].present? 
      string_to_array(data[:texts]).each do |t|
        data[t] = eval("@#{t}")
        data[t] = obj.nil? || obj[t].nil? ? '' : obj[t] if data[t].nil?
      end
      data.delete(:texts)
    end

    if data[:lists].present? # collection_name[:source_name][+field1,field2...]
      string_to_array(data[:lists]).each do |l|
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
            data[l] = raw ? collection : select_src(collection, "name", false, fields) 
        else
          data[l] = []
        end
      end
      data.delete(:lists)
    end

    if data[:list_values].present? 
      string_to_array(data[:list_values]).each do |li| 
        v = v_value(nil, nil, nil, eval("@#{li}"))        
        v = v_value(obj, li) if !v.present?
        if v.class == Integer
          v = data[li.pluralize].select {|a| a[:value] == v}
          v = v[0] if v.length
        end
        data[li] = v
      end
      data.delete(:list_values)
    end

    return data.to_json.html_safe.to_s
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
    h = {}
    h[:value] = val if val.present? 
    h[:label] = label if label.present? 
    h = h.to_json.html_safe.to_s if safe
    h
  end

end