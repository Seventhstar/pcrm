namespace :move_files do

  # task :leads => :environment do
  #    LeadsFile.all.each do |f|
  #      p f.name
  #      nf = Attachment.new
  #      nf.name = f.name
  #      nf.owner_id = f.lead_id
  #      nf.owner_type = 'Lead'
  #      nf.user_id = f.user_id
  #      nf.save
  #    end
  # end

  task :attach => :environment do
    Attachment.all.each do |f|
        num_to_s = f.owner_id.to_s
        oldname = Rails.root.join('public', 'uploads',f.owner_type,num_to_s,f.name)
        filename = Rails.root.join('public', 'uploads',f.owner_type,num_to_s,f.id.to_s+File.extname(f.name))
        File.rename(oldname,filename) if File.exist?(oldname)
    end
  end
end
