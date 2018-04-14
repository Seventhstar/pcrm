namespace :format do 

  task :phones => :environment do 
    Lead.all.each do |l|
      phone = l.phone 
      phone = phone.gsub(/[-()+ .,]/,'')
      l.update_attribute(:phone, phone)
    end
  end
  
end