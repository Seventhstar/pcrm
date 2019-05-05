require_relative '../acceptance_helper'

feature 'create/edit provider'  do

  given!(:city)    { create(:city) }

  let(:user) {create(:user)}
  let!(:p_status) {create_list(:p_status, 8)}
  let!(:gt_list) {create_list(:goodstype, 3)}

  scenario 'Simple user creates a valid provider', js: true do
    sign_in(user)
    visit providers_path

    click_on 'Добавить'

    fill_in 'provider_name', with: 'Новый поставщик'
    fill_in 'provider_phone', with: '+7 911 123456'

    fill_in 'provider_address', with: 'ул. Такая-то, 12'

    fill_in 'provider_spec', with: 'предоплата 50%'

    select_from_chosen('Двери', from: 'provider_goodstype_ids')
    select_from_chosen('Потолки', from: 'provider_goodstype_ids')

    expect(page).to have_selector('#provider_goodstype_ids_chosen .search-choice', count: 2)

    expect(page).not_to have_selector('#provider_p_status_id_chosen')
    click_on 'Сохранить'

    expect(current_path).to eql(providers_path)
    expect(page).to have_selector('#div_tproviders .panel-heading', count: 2)

    select_from_chosen('Потолки', from: 'goodstype')
    expect(page).to have_selector('#div_tproviders .panel-heading', count: 1)

    Capybara.using_session('other_user') do
      other_user = create(:user, admin: true)
      sign_in(other_user)

      visit edit_provider_path(Provider.first)
      expect(page).to have_selector('#provider_p_status_id_chosen')
      select_from_chosen('status_3', from: 'provider_p_status_id')

      

      sleep(16)
    end

  end



end