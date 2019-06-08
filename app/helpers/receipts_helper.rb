module ReceiptsHelper
  def receipt_procents_div
    div_cls = @receipt.provider_id==-1 ? '' : 'invisible'
    a ={}
    d = 25
    ind = 1
    3.times do
      cur_delim = 100/d
      cls =  !@receipt.project.nil? && (@receipt.project.total / @cl_debt > cur_delim) ? 'calc_proc' : 'calc_proc enabled'
      a[ind]= content_tag :span, d.to_s.concat('%'), {class: cls, delim: cur_delim}
      ind +=1
      d *=2
    end
    d = content_tag :span, 'Остаток', {class: 'calc_proc enabled', delim: -1, cl_debt: @cl_debt.to_sum, id: 'cl_debt' } 
    content_tag :div,{class: 'calc_div '+div_cls} do
      a[1]+a[2]+a[3]+d
    end 
  end
end
