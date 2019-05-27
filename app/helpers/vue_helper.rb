module VueHelper
  def for_vue(data, methods = [], except = [])
    except = [:created_at, :updated_at] if except.empty?

    data.to_json(except: except, methods: methods).html_safe
  end
end