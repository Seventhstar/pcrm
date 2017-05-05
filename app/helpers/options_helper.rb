module OptionsHelper

  def get_active_option_page

  	case @page
  	when 'leads','statuses','channels','lead_sources'
  		0
    when 'holidays','project_statuses','project_types','elongation_types'
      1
    when 'payment_types','payment_purposes'
      2
  	when 'providers','budgets','goodstypes','styles','p_statuses'
  		3
    when 'absence_reasons', 'absence_targets','absence_shop_targets'
      5
    when 'wiki_cats'
      6
  	else
  		4
  	end
  			
  end

end
