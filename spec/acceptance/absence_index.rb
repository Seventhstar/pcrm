require_relative '../acceptance_helper'

feature 'check sortable', 'switch'  do
  given!(:city)    { create(:city) }
  given(:user)          { create(:user) }

  let!(:absence_reasons) {create_list(:absence_reason, 5)}

  # given(:reason_miss)      { create(:absence_reason) }
  # given(:reason_to_object) { create(:absence_reason) }
  # given(:reason_to_shop)   { create(:absence_reason) }
  let!(:projects)           { create_list(:project, 3) }


  given!(:absence)    { create(:absence, reason: absence_reasons[0], user: user, 
                                dt_from:  Date.today.beginning_of_day - 3.day + 10.hours,
                                dt_to:    Date.today.beginning_of_day - 3.day + 19.hours ) }

  given!(:absence2)    { create(:absence, reason: absence_reasons[1], project: projects[2], user: user, 
                                dt_from:  Date.today.beginning_of_day - 2.day + 10.hours,
                                dt_to:    Date.today.beginning_of_day - 2.day + 19.hours ) }


  given!(:absence3)    { create(:absence, reason: absence_reasons[1], project: projects[2], user: user, 
                                dt_from:  Date.today.beginning_of_day - 1.year + 10.hours,
                                dt_to:    Date.today.beginning_of_day - 1.year + 19.hours ) }

  background do
    sign_in(user)
  end

  scenario 'search', js: true do 
    visit absences_path
    # find('.scale').click 
    # wait_for_ajax
    fill_in 'search', with: 'ул. Такая-то дом 3'
    wait_for_ajax

    # expect(page).to have_content("status_", count: 2)

    sleep 20
  end


end
