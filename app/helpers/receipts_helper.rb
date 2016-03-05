module ReceiptsHelper
	def receipt_procents_div
		p "@receipt.provider_id",@receipt.provider_id
		div_cls = @receipt.provider_id==0 ? '' : 'invisible'
		a ={}
		d = 25
		ind = 1
		3.times do
			cur_delim = 100/d
			cls =  !@receipt.project.nil? && (@receipt.project.total / @cl_debt > cur_delim) ? 'calc_proc' : 'calc_proc enabled'
			a[ind]= content_tag :span, d.to_s.concat('%'),{:class => cls, :delim => cur_delim}
			ind +=1
			d *=2
		end
    d = content_tag :span, 'Остаток',{:class => 'calc_proc enabled', :delim => -1, :cl_debt=>@cl_debt.to_sum, id: 'cl_debt' } 
		content_tag :div,{:class => 'calc_div '+div_cls} do
       a[1]+a[2]+a[3]+d
    end 
	end


	def select_options_with_special(id, nil_value, special_value = nil,collection,param_id)
		spc = special_value
		if special_value.nil?
			spc = ''
		else 
			if param_id==0 
				 spc = content_tag(:option,special_value,:value=>0, selected: 'selected' ) 
			else
				spc = content_tag(:option,special_value,:value=>0 )
			end
		end
		select_tag id, content_tag(:option,nil_value,:value=>-1)+ spc + 
				options_from_collection_for_select(collection, "id", "name", :selected => param_id)
	end

end
