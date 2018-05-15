module ProjectsHelper

  def hash_sum_on_field(total_data,field)
    total_data.map {|h| h[field] }.sum>0
  end

  def get_total_id(pgt)
    id = pgt.present? ? pgt.id : @project.id
  end

  def get_total_key(pgt)
    if @cur_id.present? && action_name!='edit'
      key = @cur_id
    else      
      item = @prj_good.nil? ? pgt : @prj_good 
      if action_name=='index' && params[:sort]=='provider_id'
        key = item.provider_id
      else
        key = item.goodstype_id
      end
    end
    key
  end

  def total_on_currencies(total_data, sum_type)
    sum_type_str = :gsum
    case sum_type
    when 2
      sum_type_str = :sum_supply
    when 3
      sum_type_str = :sum_fixed
    end

    s = ''
    currency = ['р. ','$','€']
    i = 1
    currency.each do |c|
      sum_by_currency = total_data.select {|h| h[:currency_id] == i }.first
      tsum = 0
      tsum = sum_by_currency[sum_type_str] if sum_by_currency.present?
      s += ' | ' if s.length >0 && tsum>0
      s += tsum.to_sum + c if tsum>0
      i += 1
    end
    s
  end

  def clarify_params
    years = Project.select("projects.*, date_trunc('year', date_start) AS year").where('date_start IS NOT NULL').order('date_start')
    year_from = years.first.year
    year_to = years.last.year
    @years = (year_from.year..year_to.year).step(1).to_a.reverse
    if params[:currency]
      @goods = @goods.where(currency_id: params[:currency])
    end
  end

  def get_goods(id, pgt)
    if pgt.nil?
      if action_name=='index' && params[:sort]=='provider_id'
        # provider = Provider.find(id.provider_id)
        @goods = ProjectGood.where(provider_id: id.provider_id)
        clarify_params
      else
        s_id = id.is_a?(Integer) ? id : id.project_id
        @goods = ProjectGood.where(project_id: s_id)
      end

    else
      @goods = ProjectGood.where(project_id: id, goodstype_id: pgt[0])
    end

    case @gs
    when 1 
      @goods = @goods.where(order: false)
    when 2 
      @goods = @goods.where(order: true, fixed: false)
    when 3
      @goods = @goods.where(fixed: true)
      # else 
        # @goods = @goods.where(project_id: id)
      end
    # end
  end
  
  def get_project_goods_data()

    total_data = @goods.group('currency_id')
        .select('currency_id, sum(gsum) as gsum, sum(sum_supply) as sum_supply, 
                  sum(case when fixed then sum_supply else 0 end) as sum_fixed')
        .collect{ |c| {currency_id: c.currency_id, 
                        gsum: c.gsum||0, 
                        sum_supply: c.sum_supply ||0, 
                        sum_fixed: c.sum_fixed }}
  end

  def td_sum_field( f, val = 0, label='', params = {})
    mask_cls = params[:mask] ? 'float_mask' : 'sum_mask'
    inp_add_mask = params[:inp_class].nil? ? '' : ' '+params[:inp_class]
    lbl = content_tag 'label', params[:translate] ? t(label) : label if !label.nil?
    v = params[:value]
    disabled = params[:disabled]
    v ||= @project[val] if !@project.nil?
    if f.class == String
      obj_name = f
    else
      obj_name = f.object_name
    end 

    txt = content_tag 'input', '', value: v, 
      onblur:"onBlur(this)", onfocus:"onFocus(this)", 
      class: 'txt '+mask_cls + inp_add_mask, 
        type: 'text', 
        name: "#{obj_name}[#{val}]", 
        id:   "#{obj_name}_#{val}", 
        disabled: disabled

    style = ""
    style = 'width: '+params[:width] if params[:width]

    add_class = params[:class].nil? ? '' : ' '+params[:class]
    content_tag 'td', style: style do
      content_tag 'div', class: "inp_w #{add_class}" do
        lbl.nil? ? txt : lbl+txt
      end
    end
  end

  def obj_to_link(g)
    prm = params[:sort]
    prm = 'project_id' if prm.nil?
    @cur_id = g.try(prm)
    g.try(prm.sub('_id',''))
  end


  def nil_footage(f)
    f.nil? || f==0 || f=='0.0' || f=='0'
  end

  def all_sum(g)
    gsum = g.gsum.nil? ? '' : g.gsum.to_sum
    gsum = ["<span class='striked'>",gsum,'</span>'].join if gsum.length && g.order && g.sum_supply != g.gsum
    a = gsum 
    a = [gsum,'<br>',g.sum_supply.to_sum].join if !g.sum_supply.nil? && g.sum_supply != g.gsum
    a.html_safe
  end

  def all_sum_info(g)
    gsum = g.gsum.nil? ? '' : g.gsum.to_sum
    a = 'Предложено: ' + gsum 
    a = [a,'&#013; Заказано: ',g.sum_supply.to_sum].join if !g.sum_supply.nil?
    a.html_safe
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

  def project_page_url
    sess_url  = session[:last_projects_page]
    sess_url || projects_url
  end

  def class_for_prj_goods(g)
    cls = 'placed'
    cls = 'ordered' if g.order
    cls = "fixed"   if g.fixed
    cls
  end

  def icon_for_project (prj)
    cntnt = '<div class="icons-indicate">'   
    cntnt = cntnt + image_tag('debt.png', title: 'Заказчик должен денег') if prj.debt
    cntnt = cntnt + image_tag('hammer.png', title: 'Интерес к стройке') if prj.interest
    cntnt = cntnt + image_tag('attention.png', title: 'Особое внимание') if prj.attention
    cntnt = cntnt + '</div>'
  end

  def good_state_src
    [['Предложенные', 1], ['Заказанные', 2], ['Закрытые', 3]]
  end

end
