require_relative '../acceptance_helper'

feature 'check sortable', 'switch'  do
  given!(:city)    { create(:city) }
  given(:user)     { create(:user) }
  given(:status)   { create(:status) }
  given(:status2)  { create(:status) }
  given(:status3)  { create(:status, actual: false) }
  given(:channel)  { create(:channel) }
  given(:priorities)  { create_list(:priority, 3) }

  given!(:lead)    { create(:lead, channel: channel, priority: priorities[0],
                             status: status, user: user, info: status.name,
                            ic_user: user, start_date: Date.today, 
                            status_date: Date.today, city: city) }

  given!(:lead2)    { create(:lead, channel: channel, status: status2, user: user, info: status2.name,
                            ic_user: user, start_date: Date.today, status_date: Date.today-1.month,
                            priority: priorities[1], city: city) }

  given!(:lead3)    { create(:lead, channel: channel, status: status3, user: user, info: status3.name,
                            ic_user: user, start_date: Date.today-1.year, status_date: Date.today-1.year,
                            priority: priorities[2], city: city) }

  background do
    sign_in(user)
  end

  scenario 'change year', js: true do 
    year = Date.today.year
    expect(page).to have_content(year)
    expect(page).to have_content("status_", count: 4)

    # page.execute_script('console.log(123)')
    page.execute_script("nav.year = #{year-1}")
    wait_for_ajax
    expect(page).to have_content(year-1)
    expect(page).to have_content("status_", count: 0)
    find('.scale').click 
    wait_for_ajax
    expect(page).to have_content("status_", count: 2)
    sleep 10
  end

  # scenario 'switch only_actual', js: true do
  #   visit leads_path
  #   expect(page).to have_content("status_", count: 4)
  #   sleep 5
  #   find('.scale').click 
  #   sleep 20
  #   wait_for_ajax
  #   expect(page).to have_content("status_", count: 6)
  # end

  # scenario 'year_chosen', js: true do 
  #   # year = find('#year_chosen')
  #   # year.click
  #   # within year do 
  #   #   find_all('.active-result')[1].click
  #   # end

  #   # expect(page).to have_content("status_", count: 4)
  # end

  # scenario 'search', js: true do 
  #   find('.scale').click 
  #   wait_for_ajax
  #   fill_in 'search', with: 'status_7'
  #   wait_for_ajax
  #   expect(page).to have_content("status_", count: 2)
  # end


end
