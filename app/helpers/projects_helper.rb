module ProjectsHelper
	def td_sum_field( f, val = 0, label='', flt=false )
		#<td><div class="inp_w"><%= f.text_field :price, label: 'Цена за м2', class: "txt sum_mask" %></div></td>
		mask_cls = flt ? 'float_mask' : 'sum_mask'
		lbl = content_tag 'label', t(label)
		txt = content_tag 'input', '',value: @project[val], onblur:"onBlur(this)", onfocus:"onFocus(this)", class: 'txt '+mask_cls, type: 'text', name: "#{f.object_name}[#{val}]" , id: "#{f.object_name}_#{val}"
		content_tag 'td' do
			content_tag 'div', class: 'inp_w' do
				lbl + txt
			end
		end
	end
end
