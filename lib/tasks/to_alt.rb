namespace :gmove do   
  
  task :lead_reindex => :environment do
    Lead.reindex
  end
end