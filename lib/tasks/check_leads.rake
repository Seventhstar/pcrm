namespace :check_leads do

  task :reminder_mail => :environment do
    today = DateTime.now.beginning_of_day.to_date
    l = Lead.where('status_date between ? and ?', today, DateTime.now.tomorrow.to_date ).order('ic_user_id,status_date')
    ic_user = nil
    l_today  = []
    l_tomorrow = []
    l.each do |lead|
      if ic_user != lead.ic_user_id
         LeadMailer.reminder_email(ic_user,l_today,l_tomorrow).deliver if !ic_user.nil?
         l_today = []
         t_tomorrow = []
         ic_user = lead.ic_user_id 
      end
      if lead.status_date == today
         l_today << lead.id
      else
         l_tomorrow << lead.id
      end
    end
    LeadMailer.reminder_email(ic_user,l_today,l_tomorrow).deliver if !ic_user.nil?
  end

end
