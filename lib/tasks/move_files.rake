namespace :move_files do

  task :leads => :environment do
     LeadsFile.all.each do |f|
       p f.name
       nf = Attachment.new
       nf.name = f.name
       nf.owner_id = f.lead_id
       nf.owner_type = 'Lead'
       nf.user_id = f.user_id
       nf.save
     end
  end

end
