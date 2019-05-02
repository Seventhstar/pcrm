require_relative '../acceptance_helper'

feature 'create/edit absence'  do

  given!(:city) { create(:city) }
  given!(:roles) { create_list(:role, 3) }

  scenario 'Authenticated user creates a valid absence', js: true do
    create_list(:absence_reason, 6)
    create_list(:absence_target, 4)
    create_list(:absence_shop_target, 2)
    create_list(:provider, 2)

    manager = create(:user_manager)
    project = create(:project, executor: manager)
    sign_in(manager)

    visit absences_path
    click_on 'Добавить'

    expect(page).not_to have_content 'Проект'

    expect(page).to have_css('.btn_a.disabled')

    page.execute_script('app.reason  = app.reasons[1]')
    page.execute_script('app.project = app.projects[0]')
    page.execute_script('app.target  = app.targets[0]')
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

    click_on 'Добавить'
    expect(page).not_to have_css('.shops') # таблицу с магазинами не видно
    expect(page).to have_css('.btn_a.disabled') # добавить магазин кнопка не активна
    page.execute_script('app.project = app.projects[0]')

    page.execute_script('app.reason = app.reasons[2]') # после выбора выезда магазин
    expect(page).to have_css('.shops') # появляетя таблица с магазинами

    expect(find('#new_item .btn_a')[:disabled]).to eq("true") # кнопка добавить магазин - не активна

    find('#new_item .btn_a').click #
    
    expect(page).to have_selector('#absence_shops_ tr', count: 1)

    expect(has_css?("input.disabled[type=submit]", wait: 0)).to eq(true) # кнопка сохранить не активна

    page.execute_script('app.new_shop = app.new_shops[0]') # 
    expect(find('#new_item .btn_a')[:disabled]).to eq("true")
    page.execute_script('app.new_shop_target = app.new_shop_targets[0]')

    expect(find('#new_item .btn_a')[:disabled]).to eq(nil) # после заполнения полей, добавить магазин доступна

    find('#new_item .btn_a').click # 

    expect(page).to have_selector('#absence_shops_ tr', count: 2)

    # sleep(15)
    expect(has_css?("input.disabled[type=submit]", wait: 0)).to eq(false) # кнопка сохранить доступна

    find('input[name="commit"]').click
  end


end