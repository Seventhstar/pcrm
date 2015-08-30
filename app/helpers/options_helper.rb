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

end
