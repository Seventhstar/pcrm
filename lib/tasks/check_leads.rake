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
   
    projects.each do |prj|
      ProjectMailer.reminder_email(prj).deliver
    end


    prj = Project.where(" pstatus_id =  1 and date_end_plan < ?",Date.today).pluck(:id)
    all_pe = ProjectElongation.where(project_id: prj).pluck(:project_id).uniq
    pe = ProjectElongation.select(:id, :project_id,:new_date).where('project_id in (?)',prj).group(:project_id).maximum(:new_date)
    
    prj_wo_pe = prj - all_pe

    all = prj_wo_pe + pe.select{|k, v| v < Date.today }.keys
	all.each do |prj_id|
		ProjectMailer.overdue_email(prj_id).deliver
	end


  end

end
