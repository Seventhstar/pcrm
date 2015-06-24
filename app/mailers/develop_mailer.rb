class DevelopMailer < ActionMailer::Base
  default from: "service@crmpp.ru" 
  include CommonHelper
  include DevelopsHelper
  add_template_helper(CommonHelper)
  add_template_helper(DevelopsHelper)

  def send_mail_to_admins( subj)
    if Rails.env.production?
      admins = User.where('admin = true and id <> 10')
      emails = admins.collect(&:email).join(",")
      #puts "emails: "  + emails
      #emails = User.first.email
      mail(:to => emails, :subject => subj) do |format|

        format.html 
      end
    end
  end

  def changeset_email(dev_id)
    @dev = Develop.find(dev_id)
    #puts "dev_id: "+ dev_id.to_s
    @history = get_last_history_item(@dev) 
     puts "history:"+ @history.to_s
    @version = @dev.versions.last
    send_mail_to_admins("Изменения в задаче")
    
  end


  def created_email(dev_id)
    @dev = Develop.find(dev_id)
    #user = User.first
    @history = get_last_history_item(@dev) 
    @version = @dev.versions.last

    send_mail_to_admins("Создана новая задача")
  
  end

end
