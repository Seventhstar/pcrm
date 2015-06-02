module OptionsHelper

  def get_active_option_page

  	case params['options_page']
  	when 'leads','statuses','channels'
  		0
  	when 'providers','budgets','goodstypes','styles','p_statuses'
  		1
  	else
  		2
  	end
  			
  end

  def list_header( cls )
  case cls
    when "Style"
      "Список стилей"
    when "Budget"
      "Список бюджетов"
    when "Goodstype"
      "Список видов товаров"
    when "Channel"
      "Список каналов"
    when "Status"
      "Список статусов"    
    when "PStatus"
      "Список статусов"    
    when "DevProject"
      "Список проектов разработки"    
    when "DevStatus"
      "Список статусов задач"    
    when "Priority"
	  "Список приоритетов"        	
    else
      cls
    end
  end

  def new_item_header( cls )
  case cls
    when "Style"
      "Новый стиль"
    when "Budget"
      "Новый бюджет"
    when "Goodstype"
      "Новый вид товаров"
    when "Channel"
      "Новый канал"
    when "Status"
      "Новый статус"    
    when "PStatus"
      "Новый статус" 
    when "DevProject"   
      "Новый проект"
    when "DevStatus"
      "Новый статус"    
    when "Priority"
      "Новый приоритет"           
    else
      cls
    end
  end


end
