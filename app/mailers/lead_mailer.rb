class LeadMailer < ActionMailer::Base
  include CommonHelper
  include LeadsHelper
  add_template_helper(CommonHelper)
  add_template_helper(LeadsHelper)

  def send_mail_to_admins( subj )
    
  	if Rails.env.production?
  		admins = User.where('admin = true and id <> 10')
  	else
  		admins = User.where("admin = 't' and id <> 10").to_a
  	end

      admins = admins | [@lead.user]
      admins = admins | [@lead.ic_user]
      
      $stdout.puts "admins count:" + admins.count.to_s
      emails = admins.collect(&:email).join(",")
      $stdout.puts "emails:" + emails

    if Rails.env.production?
#      mail(:to => emails, :subject => subj) do |format|
#        format.html 
#      end
    end
  end

  def changeset_email(lead_id)
    @lead = Lead.find(lead_id)
    puts "lead_id: "+ lead_id.to_s
    @history = get_last_history_item(@lead) 
    @version = @lead.versions.last
    send_mail_to_admins("Изменения в лиде")
    
  end


  def created_email(dev_id)
    @dev = Develop.find(dev_id)
    #user = User.first
    @history = get_last_history_item(@dev) 
    @version = @dev.versions.last

    send_mail_to_admins("Создана новый лид")
  
  end

end
