module ProjectsHelper
	def td_sum_field( f, val = 0, label='', params = {})
		mask_cls = params[:mask] ? 'float_mask' : 'sum_mask'
    inp_add_mask = params[:inp_class].nil? ? '' : ' '+params[:inp_class]
		lbl = content_tag 'label', params[:translate] ? t(label) : label
    v = params[:value]
    v ||= @project[val]
		txt = content_tag 'input', '', value: v, onblur:"onBlur(this)", onfocus:"onFocus(this)", class: 'txt '+mask_cls + inp_add_mask, type: 'text', name: "#{f.object_name}[#{val}]" , id: "#{f.object_name}_#{val}"
		add_class = params[:class].nil? ? '' : ' '+params[:class]
		content_tag 'td' do
			content_tag 'div', class: 'inp_w'+add_class do
				lbl + txt
			end
		end
	end

  def nil_footage(f)
    i = !f.nil? && f!=0 && f!='0.0' && f!='0'
    !i
  end

  def class_for_project (prj)
    cls = ''
    cls = 'hot_date' if !prj.date_end.nil? && prj.date_end <= Date.today+1
    cls = "nonactual" if prj.pstatus_id == 3
    cls = 'hot ' if prj.pstatus_id == 2
    cls
  end

  def business_days_between(date1, date2)
    hdays = Holiday.pluck(:day)
    business_days = 0
    date = date2
    while date > date1
     business_days = business_days + 1 unless date.saturday? or date.sunday? or hdays.include?(date)
     date = date - 1.day
    end
    business_days
  end

  def project_stored_page_url
      sess_url  = session[:last_prj_page]
      sess_url || projects_url
      p sess_url
  end


end
