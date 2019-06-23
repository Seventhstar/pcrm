require_relative '../acceptance_helper'

feature 'create/edit project'  do

  given!(:city)    { create(:city) }
  given!(:user)    { create(:user, admin: true) }
  # given!(:channel) { create(:channel)}



  scenario 'Authenticated user creates a valid project', js: true do
    sign_in(user)
    visit projects_path

    click_on 'Добавить'
#    sleep(5)


    click_on 'Сохранить'
    expect(current_path).to eql(new_project_path)
 #   sleep(15)

    # expect(page).to redirect_to(projects_path)
    # sleep(3)
  end



end