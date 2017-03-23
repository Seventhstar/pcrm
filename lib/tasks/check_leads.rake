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


    pe_tod = ProjectElongation.where('new_date = ?',Date.today).pluck(:project_id)
    pe_tom = ProjectElongation.where('new_date = ?', Date.today+1).pluck(:project_id)
    
    pe  = ProjectElongation.pluck(:project_id).compact.uniq
    p_tod = Project.where('date_end_plan = ?',Date.today).pluck(:project_id)
    p_tom = Project.where('date_end_plan = ?',Date.today+1).pluck(:project_id)
    p_tod = p_tod - pe + pe_tod
    p_tom = p_tom - pe + pe_tom

    projects = Project.where(:id in [p_tod,p_tom])

    ex_user = nil
    p_today  = []
    p_tomorrow = []
    pe.each do |p_el|
      if ex_user != pe.project.executor_id
         ProjectMailer.reminder_email(ex_user,p_today,p_tomorrow).deliver if !ex_user.nil?
         p_today = []
         p_tomorrow = []
         ex_user = pe.project.executor_id 
      end
      if p_el.new_date.status_date == today
         p_today << p_el.project_id
      else
         p_tomorrow << p_el.project_id
      end
    end


  end

end
