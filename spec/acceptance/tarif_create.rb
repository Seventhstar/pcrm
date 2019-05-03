require_relative '../acceptance_helper'

feature 'create/edit lead & add comment'  do

  given!(:city)    { create(:city) }

  let(:user) {create(:user)}
  let!(:project_type) {create(:project_type)}
  let!(:tarif_calc_type) {create(:tarif_calc_type)}

  scenario 'Authenticated user creates a valid lead', js: true do
    sign_in(user)
    visit tarifs_path

    click_on 'Добавить'

    page.execute_script('app.project_type = app.project_types[0]')
    page.execute_script('app.tarif_calc_type = app.tarif_calc_types[0]')

    # find('.switcher_a').first.click
    expect(page).to have_selector('#tarif_sum2', visible: false)
    all('div', class: 'switcher_a').first.click
    expect(page).to have_selector('#tarif_sum2', visible: true)

    # expect(find('#tarif_sum2', visible: false)).to eq(true)
    fill_in 'tarif_sum', with: '5000'
    fill_in 'tarif_sum2', with: '4000'
   
    expect(page).not_to have_content('при площади объекта от м2')
    all('div', class: 'switcher_a')[1].click
    expect(page).to have_content('при площади объекта от м2')

    fill_in 'tarif_from', with: '100'
    expect(page).not_to have_content('при площади объекта от м2')
    expect(page).to have_content('при площади объекта от 100.00 м2')

    expect(has_css?("input.disabled[type=submit]", wait: 0)).to eq(true) # кнопка сохранить не активна
    fill_in 'tarif_value_price', with: '100'
    expect(has_css?("input.disabled[type=submit]", wait: 0)).to eq(false) # кнопка сохранить не активна

    click_on 'Сохранить'
    sleep(15)


    # fill_in 'lead_footage', with: 120
    # fill_in 'lead_first_comment', with: 'Новый коммент'
    

    # expect(current_path).to eql(leads_path)
  end



end