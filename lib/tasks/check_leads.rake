namespace :check_leads do

  task :reminder_mail => :environment do
    today = Date.today
    l = Lead.where('status_date between ? and ?', today, today+1 ).order('ic_user_id,status_date')
    ic_user = nil
    l_today  = []
    l_tomorrow = []
    l.each do |lead|
      if ic_user != lead.ic_user_id
         LeadMailer.reminder_email(ic_user,l_today,l_tomorrow).deliver if !ic_user.nil?
         l_today = []
         l_tomorrow = []
         ic_user = lead.ic_user_id 
      end
      if lead.status_date == today
         l_today << lead.id
      else
         l_tomorrow << lead.id
      end
    end
    LeadMailer.reminder_email(ic_user,l_today,l_tomorrow).deliver if !ic_user.nil?


    pe_todtom = ProjectElongation.where('new_date between ? and ?',Date.today, Date.today+1).pluck(:project_id)
    pe  = ProjectElongation.pluck(:project_id).compact.uniq
    p_todtom = Project.where('date_end_plan between ? and ?',Date.today,Date.today+1).pluck(:id)
    p_todtom = p_todtom - pe + pe_todtom
    projects = Project.where(:id => [p_todtom]).order('executor_id')
    # p projects.count
    ex_user = nil
    p_today  = []
    p_tomorrow = []
    projects.each do |prj|
      if ex_user != prj.executor_id
         ProjectMailer.reminder_email(ex_user,p_today,p_tomorrow).deliver if !ex_user.nil?
         p_today = []
         p_tomorrow = []
         ex_user = prj.executor_id 
      end
      if prj.date_end == today
         p_today << prj.id
      else
         p_tomorrow << prj.id
      end
    end
    ProjectMailer.reminder_email(ex_user,p_today,p_tomorrow).deliver if !ex_user.nil?

  end

end
