require_relative '../acceptance_helper'

feature 'create/edit absence'  do

  given!(:city) { create(:city) }

  # given!(:hooky) { create(:absence_reason, name: 'Прогул') }
  # given!(:going_to_object) { create(:absence_reason, name: 'Выезд на объект') }

  scenario 'Authenticated user creates a valid absence', js: true do
    create_list(:role, 3)
    create_list(:absence_reason, 6)
    create_list(:absence_target, 4)

    manager = create(:user_manager)
    project = create(:project, executor: manager)
    sign_in(manager)

    visit absences_path
    click_on 'Добавить'

    expect(page).not_to have_content 'Проект'
    # expect
    expect(page).to have_css('.btn_a.disabled')

    page.execute_script('app.reason = app.reasons[1]')
    page.execute_script('app.project = app.projects[0]')
    page.execute_script('app.target = app.targets[0]')
    wait_for_ajax
    
    expect(page).to have_content 'Проект'
    expect(page).not_to have_css('.btn_a.disabled')

    click_on 'Сохранить'
    expect(current_path).to eql(absences_path)


    click_on 'Добавить'
    page.execute_script('app.reason = app.reasons[5]')
    expect(page).to have_css('.btn_a.disabled')
    fill_in 'absence_comment', with: 'По важным обстоятельствам'
    expect(page).not_to have_css('.btn_a.disabled')
    click_on 'Сохранить'
    expect(current_path).to eql(absences_path)

    # sleep(10)
    # fill_in ''
    # fill_in 'wiki_record_name', with: 'Новая папка'


    # click_on 'Новое знание'
    # fill_in 'wiki_record_name', with: 'Новая секретная папка'
    # find(:css, "#wiki_record_admin").set(true)
    # click_on 'Сохранить'

    # expect(page).to have_content 'Новая секретная папка'

    # click_on 'Новое знание'    
    # fill_in 'wiki_record_name', with: 'Новое знание'

    # select_from_chosen('Новая папка', from: 'wiki_record_parent_id')
    # page.execute_script('$(tinymce.editors[0].setContent("Новое описание знания"))')

    # click_on 'Сохранить'

    # expect(current_path).to eql(wiki_records_path)
    # expect(page).to have_selector('.wiki_name', count: 2)

    # sleep 1
    # all('span', class: 'folder').first.click
    # wait_for_ajax
    # expect(page).to have_selector('.wiki_name', count: 3)

    # # all('span', class: 'folder')[1].click
    # find(:css, ".child_data .folder").click
    # wait_for_ajax
    # expect(page).to have_content 'Новое описание знания'

    # Capybara.using_session('other_user') do
    #   other_user = create(:user)
    #   sign_in(other_user)
    #   visit wiki_records_path
    #   expect(page).to have_content 'Новая папка'
    #   expect(page).not_to have_content 'Новая секретная папка'
    # end

  end


end