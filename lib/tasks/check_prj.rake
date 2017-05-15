namespace :check_prj do

  task :reminder_mail => :environment do
    prj = Project.where(pstatus_id: 1).pluck(:id)
    pe_todtom = ProjectElongation.select(:id, :project_id,:new_date).where('project_id in (?)',prj).group(:project_id).maximum(:new_date)
    pe_todtom.select{|key, hash| hash["client_id"] == "2180" }
    p  pe_todtom
  end

end
