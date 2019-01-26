require_relative '../acceptance_helper'

feature 'create/edit lead'  do

  # given(:city)    { create(:city) }
  given!(:user)    { create(:user) }
  given!(:channel) { create(:channel) }
  given!(:status)  { create(:status) }
  given!(:priority)  { create(:priority) }


  # given(:lead) { create(:lead, channel: channel, status: status, user: user, info: status.name,
                            # ic_user: user, start_date: Date.today, status_date: Date.today,
                            # city: city) }


  scenario 'Authenticated user creates a valid lead', js: true do
    sign_in(user)
    visit leads_path

    click_on 'Добавить'

    fill_in 'lead_info', with: 'Новый лид'
    fill_in 'lead_footage', with: 120
    fill_in 'lead_first_comment', with: 'Новый коммент'
    # find("#lead_channel_id_chosen").click
    click_on 'Сохранить'

    expect(page).to redirect_to(leads_path)
    # sleep(10)
  end



end