module ProjectsHelper
	def td_sum_field( f, val = 0, label='', params = {})
		mask_cls = params[:mask] ? 'float_mask' : 'sum_mask'
		lbl = content_tag 'label', params[:translate] ? t(label) : label
    v = params[:value]
    v ||= @project[val]
		txt = content_tag 'input', '', value: v, onblur:"onBlur(this)", onfocus:"onFocus(this)", class: 'txt '+mask_cls, type: 'text', name: "#{f.object_name}[#{val}]" , id: "#{f.object_name}_#{val}"
		add_class = params[:class].nil? ? '' : ' '+params[:class]
		content_tag 'td' do
			content_tag 'div', class: 'inp_w'+add_class do
				lbl + txt
			end
		end
	end

  def business_days_between(date1, date2)
    business_days = 0
    date = date2
    while date > date1
     business_days = business_days + 1 unless date.saturday? or date.sunday?
     date = date - 1.day
    end
    business_days
  end



end
