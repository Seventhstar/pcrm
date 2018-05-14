FactoryBot.define do
  sequence :info do |n|
    "Lead #{n} text"
  end

 factory :lead do
  info 
  status 
  channel
  ic_user = user
  # user
      # puts "ic_user #{ic_user}" 
      # ic_user = User.first 
  start_date = Date.today
  status_date = Date.today
  end
end