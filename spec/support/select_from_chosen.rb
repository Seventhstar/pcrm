module SelectFromChosen
  # select_from_chosen('Option', from: 'id_of_field')
  # def fill_chosen(item_text, options)
  def fill_chosen(id, options)
    # field = find_field(options[:from], visible: false)
    field = find_field(id, visible: false)
    find("##{field[:id]}_chosen").click
    # find("##{field[:id]}_chosen ul.chosen-results li", text: item_text).click
    find("##{field[:id]}_chosen ul.chosen-results li", text: options[:with]).click
  end
end