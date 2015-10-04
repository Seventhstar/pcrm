module ProjectsHelper
	def td_sum_field( f, val = 0, label )
		#<td><div class="inp_w"><%= f.text_field :price, label: 'Цена за м2', class: "txt sum_mask" %></div></td>
		lbl = content_tag 'label', label
		txt = content_tag 'input', '',value: @project[val], class: 'txt sum_mask', type: 'text', name: "#{f.object_name}[#{val}]" , id: "#{f.object_name}_#{val}"
		content_tag 'td' do
			content_tag 'div', class: 'inp_w' do
				lbl + txt
			end
		end
	end
end
