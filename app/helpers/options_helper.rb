module OptionsHelper

  def get_active_option_page

  	case params['options_page']
  	when 'leads','statuses','channels'
  		0
    when 'project_statuses','project_types'
      1
    when 'payment_types','payment_purposes'
      2
  	when 'providers','budgets','goodstypes','styles','p_statuses'
  		3
    when 'absence_reasons', 'absence_targets','absence_shop_targets'
      5
  	else
  		4
  	end
  			
  end

end
