module ProjectsHelper

	def td_sum_field( f, val = 0, label='', params = {})
		mask_cls = params[:mask] ? 'float_mask' : 'sum_mask'
    inp_add_mask = params[:inp_class].nil? ? '' : ' '+params[:inp_class]
		lbl = content_tag 'label', params[:translate] ? t(label) : label if !label.nil?
    v = params[:value]
    v ||= @project[val] if !@project.nil?
    if f.class == String
      obj_name = f
    else
      obj_name = f.object_name
    end 

		txt = content_tag 'input', '', value: v, onblur:"onBlur(this)", onfocus:"onFocus(this)", class: 'txt '+mask_cls + inp_add_mask, type: 'text', name: "#{obj_name}[#{val}]" , id: "#{obj_name}_#{val}"
		add_class = params[:class].nil? ? '' : ' '+params[:class]
		content_tag 'td' do
			content_tag 'div', class: 'inp_w'+add_class do
				lbl.nil? ? txt : lbl+txt
			end
		end
	end

  def nil_footage(f)
    f.nil? || f==0 || f=='0.0' || f=='0'
  end


  def class_prj_td (prj)
    cls = ''
    cls = 'green '    if prj.pstatus_id == 4
    cls = 'hot_date'  if !prj.date_end.nil? && prj.date_end <= Date.today+1
    cls = 'hot '      if prj.pstatus_id == 2
    cls
  end


  def class_for_project (prj)
    cls = ''
    cls = 'green '    if prj.pstatus_id == 4
    cls = "nonactual" if prj.pstatus_id == 3
    cls = 'hot '      if prj.pstatus_id == 2
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
  end

  def icon_for_project (prj)
      cntnt = '<div class="icons-indicate">'   
      cntnt = cntnt + image_tag('debt.png', title: 'Заказчик должен денег') if prj.debt
      
      cntnt = cntnt + image_tag('25.png', title: '25% процентов оплаты') if prj.payd_q
      cntnt = cntnt + image_tag('100.png', title: 'Оплачен, но не сдан') if prj.payd_full

      cntnt = cntnt + image_tag('hammer.png', title: 'Интерес к стройке') if prj.interest
      
      if is_admin? && prj.comments.count>0
        if !prj.comments.last.receivers.find_by_user_id(current_user.id).nil?
         #   cntnt = cntnt + image_tag('comment_unread.png', title: 'Есть комментарии') 
         # else
          cntnt = cntnt + image_tag('comment.png', title: 'Новый комментарий')
        end
      end

      cntnt = cntnt + image_tag('attention.png', title: 'Особое внимание') if prj.attention
      cntnt = cntnt + image_tag('stopped.png', title: 'Проект приостановлен') if prj.pstatus_id == 2
      cntnt = cntnt + '</div>'
  end

end
