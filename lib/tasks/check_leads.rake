namespace :check_leads do

  task :reminder_mail => :environment do
    today = Date.today
    l = Lead.where('status_date between ? and ?', today, today+1).order('ic_user_id,status_date')
    ic_user = nil
    l_today = []
    l_tomorrow = []
    l.each do |lead|
      if ic_user != lead.ic_user_id
        LeadMailer.reminder_email(ic_user, l_today, l_tomorrow).deliver if !ic_user.nil?
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
    LeadMailer.reminder_email(ic_user, l_today, l_tomorrow).deliver if !ic_user.nil?

    # todo - перенести в check_prj в cron
    # выбираем проекты со сроком окончания не раньше завтрашнего дня
    prj = Project.where(" pstatus_id =  1 and date_end_plan < ?", Date.today).pluck(:id)
    prj_todtom = Project.where('date_end_plan between ? and ?', Date.today, Date.today+2).pluck(:id)

    # смотрим все продления со статусом 1 = в работе
    prj_ids = Project.where(pstatus_id: 1).pluck(:id)
    all_pe = ProjectElongation.where(project_id: prj_ids).pluck(:project_id).uniq

    # отбираем для них последние даты продления
    pe = ProjectElongation.select(:id, :project_id, :new_date).where('project_id in (?)', prj+prj_todtom).group(:project_id).maximum(:new_date)

    prj_wo_pe = prj_todtom - all_pe
    prjs_ids = prj_wo_pe + pe.select {|k, v| v < Date.today + 2 && v >= Date.today}.keys
    prjs_ids.each do |prj_id|
      ProjectMailer.reminder_email(prj_id).deliver
    end

    prj_wo_pe = prj - all_pe
    prjs_ids = prj_wo_pe + pe.select {|k, v| v < Date.today}.keys
    prjs_ids.each do |prj_id|
      ProjectMailer.overdue_email(prj_id).deliver
    end


  end

end
