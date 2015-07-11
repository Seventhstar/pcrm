namespace :check_leads do

  task :reminder_mail => :environment do
    today = DateTime.now.beginning_of_day.to_date
    l = Lead.where('status_date between ? and ?', today, DateTime.now.tomorrow.to_date ).order('ic_user_id,status_date')
    ic_user = nil
    l_today  = []
    l_tomorrow = []
    l.each do |lead|
      p "lead.ic_user_id: " + lead.ic_user_id.to_s + ", ic_user: " + ic_user.to_s
      if ic_user != lead.ic_user_id
         if !ic_user.nil?
         	p lead.ic_user_name
            p l_today,l_tomorrow
         end
         l_today = []
         t_tomorrow = []
         ic_user = lead.ic_user_id 
      end
      if lead.status_date = today
         l_today<< lead.id
      else
         l_tt_tomorrow << lead.id
      end
    end
    p l_today,l_tomorrow
  end

end
