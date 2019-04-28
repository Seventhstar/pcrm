require_relative '../acceptance_helper'

feature 'create/edit lead & add comment'  do

  given!(:city)    { create(:city) }
  given!(:user)    { create(:user) }
  given!(:channel) { create(:channel)}
  given!(:channel2) { create(:channel)}
  given!(:status)  { create(:status)  }
  given!(:priority){ create(:priority) }

  let(:user) {create(:user)}
  let(:lead) {create(:lead, channel: channel, 
                             status: status, user: user, info: status.name,
                            ic_user: user, start_date: Date.today, 
                            status_date: Date.today, city: city) }

  scenario 'Authenticated user creates a valid lead', js: true do
    sign_in(user)
    visit leads_path

    click_on 'Добавить'

    fill_in 'lead_info', with: 'Новый лид'
    fill_in 'lead_footage', with: 120
    fill_in 'lead_first_comment', with: 'Новый коммент'
    
    click_on 'Сохранить'

    expect(current_path).to eql(leads_path)


  end

  scenario 'Add second comment', js: true do
    visit edit_lead_path(Lead.first)    
    fill_in 'comment_comment', with: 'Еще новее комментарий'
    find('span', text: 'Отправить').click

  end


  scenario 'Add second comment', js: true do
      other_user = create(:user, admin: true)
      sign_in(other_user)


      # puts "#{Lead.count}"
      visit edit_lead_path(Lead.first)    
      fill_in 'comment_comment', with: 'Еще новее комментарий'
      find('span', text: 'Отправить').click
      wait_for_ajax
      expect(page).to have_selector('.comments_list_a li', count: 2)
      
      attach_file 'attach_list', "#{Rails.root}/spec/spec_helper.rb", make_visible: true
      # attach_file('file[picture]', 'path/to/file.png', make_visible: true)
      # find('a', text: 'Добавить файл').click
      # all('input[type="file"]').last.set("#{Rails.root}/spec/rails_helper.rb")
      # click_on ''
      sleep(25)
  end

  #     click_on 'Create'


end