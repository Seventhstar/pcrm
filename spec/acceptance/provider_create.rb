require_relative '../acceptance_helper'

feature 'create/edit provider'  do

  given!(:city)    { create(:city) }

  let(:user) {create(:user)}
  let!(:p_status) {create_list(:p_status, 8)}
  let!(:gt_list) {create_list(:goodstype, 3)}

  scenario 'Simple user creates a valid provider', js: true do
    position_director = create(:position, name: 'Директор', secret: true)
    position_manager = create(:position)

    Capybara.using_session('user') do
      sign_in(user)
      visit providers_path

      click_on 'Добавить'

      fill_in 'provider_name', with: 'Новый поставщик'
      fill_in 'provider_phone', with: '+7 911 123456'
      fill_in 'provider_address', with: 'ул. Такая-то, 12'
      fill_in 'provider_spec', with: 'предоплата 50%'

      fill_chosen 'provider_goodstype_ids', with: 'Двери'
      fill_chosen 'provider_goodstype_ids', with: 'Потолки'

      expect(page).to have_selector('#provider_goodstype_ids_chosen .search-choice', count: 2)

      expect(page).not_to have_selector('#provider_p_status_id_chosen')
      click_on 'Сохранить'
      sleep 1

      expect(current_path).to eql(providers_path)
      expect(page).to have_selector('#div_tproviders .panel-heading', count: 2)

      fill_chosen 'goodstype', with: 'Потолки'
      expect(page).to have_selector('#div_tproviders .panel-heading', count: 1)
    end

    Capybara.using_session('other_user') do
      other_user = create(:user, admin: true)
      sign_in other_user

      visit edit_provider_path(Provider.first)
      expect(page).to have_selector('#provider_p_status_id_chosen')
      fill_chosen 'provider_p_status_id', with: 'status_3'


      expect(page).to have_content 'Важные детали'
      fill_in 'special_info_content', with: 'Новое важное описание'
      find('#btn-special-info').click

      expect(page).not_to have_content 'Новый комментарий'
      find('#ui-id-1').click # переключаемся на общие комментарии
      # теперь новое важное описание не видно, но есть на странице
      expect(page).to have_selector('p', text: "Новое важное описание", visible: false, count: 1)
      
      fill_in 'comment_comment', with: 'Новое обычное описание'
      find('#btn-chat').click

      fill_chosen 'manager_position_id', with: 'Директор'
      fill_in 'manager_name', with: 'Иванов Иван Иваныч'
      fill_in 'manager_phone', with: '+7 981 111 22 33'

      find('#btn-sub-send').click

      fill_chosen 'manager_position_id', with: 'Менеджер'
      fill_in 'manager_name', with: 'Сидоров Семен Михайлович'
      fill_in 'manager_phone', with: '+7 981 111 23 45'
      find('#btn-sub-send').click
    end

    Capybara.using_session('user') do
      visit edit_provider_path(Provider.first)
      expect(page).not_to have_content 'Директор'
      expect(page).to have_content 'Менеджер'
      expect(page).not_to have_content 'Важные детали'
      expect(page).to have_selector('p', text: "Новое важное описание", visible: false, count: 0)
    end

  end

end