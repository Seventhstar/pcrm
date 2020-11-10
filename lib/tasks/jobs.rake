namespace :jobs do
  task test_bot: :environment do
    lead = Lead.find(1883)
    SendToTelegramJob.perform_now lead
  end
end