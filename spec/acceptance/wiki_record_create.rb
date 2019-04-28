require_relative '../acceptance_helper'

feature 'create/edit wiki_record'  do

  given!(:city) { create(:city) }

  scenario 'Authenticated user creates a valid folder and child', js: true do
    create_list(:role, 3)
    manager = create(:user_manager)
    sign_in(manager)

    visit wiki_records_path
    click_on 'Новое знание'

    fill_in 'wiki_record_name', with: 'Новая папка'
    click_on 'Сохранить'

    expect(current_path).to eql(wiki_records_path)

    click_on 'Новое знание'
    fill_in 'wiki_record_name', with: 'Новая секретная папка'
    find(:css, "#wiki_record_admin").set(true)
    click_on 'Сохранить'

    expect(page).to have_content 'Новая секретная папка'

    click_on 'Новое знание'    
    fill_in 'wiki_record_name', with: 'Новое знание'

    select_from_chosen('Новая папка', from: 'wiki_record_parent_id')
    page.execute_script('$(tinymce.editors[0].setContent("Новое описание знания"))')

    click_on 'Сохранить'

    expect(current_path).to eql(wiki_records_path)
    expect(page).to have_selector('.wiki_name', count: 2)

    sleep 1
    all('span', class: 'folder').first.click
    wait_for_ajax
    expect(page).to have_selector('.wiki_name', count: 3)

    # all('span', class: 'folder')[1].click
    find(:css, ".child_data .folder").click
    wait_for_ajax
    expect(page).to have_content 'Новое описание знания'

    Capybara.using_session('other_user') do
      other_user = create(:user)
      sign_in(other_user)
      visit wiki_records_path
      expect(page).to have_content 'Новая папка'
      expect(page).not_to have_content 'Новая секретная папка'
    end

  end


end