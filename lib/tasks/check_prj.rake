namespace :check_prj do

	task :reminder_mail => :environment do
		prj = Project.where(" pstatus_id =  1 and date_end_plan < ?",Date.today).pluck(:id)
		prj_ids = Project.where(pstatus_id: 1).pluck(:id)
		all_pe = ProjectElongation.where(project_id: prj_ids).pluck(:project_id).uniq
		pe = ProjectElongation.select(:id, :project_id,:new_date).where('project_id in (?)',prj).group(:project_id).maximum(:new_date)

		prj_wo_pe = prj - all_pe

		all = prj_wo_pe + pe.select{|k, v| v < Date.today }.keys
		all.each do |prj_id|
			ProjectMailer.overdue_email(prj_id).deliver
			
			
			
		end 

	end


 
end
