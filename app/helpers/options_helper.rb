module OptionsHelper

  def get_active_option_page

    case @page
    when 'users', 'roles', 'user_roles'
      0
    when 'leads', 'statuses', 'channels', 'lead_sources', 'styles'
      1
    when 'holidays', 'project_statuses', 'project_types', 'elongation_types', 'contact_kinds'
      2
    when 'uoms'
      3
    when 'payment_types', 'payment_purposes'
      4
    when 'providers', 'budgets', 'goodstypes', 'styles', 'p_statuses'
      6
    when 'absence_reasons', 'absence_targets', 'absence_shop_targets'
      7
    when 'wiki_cats'
      8
    else
      5
    end

  end

end
