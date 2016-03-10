class DevelopMailer < ActionMailer::Base
  default from: "service@crmpp.ru" 
  include CommonHelper
  include DevelopsHelper
  add_template_helper(CommonHelper)
  add_template_helper(DevelopsHelper)

  def send_mail_to_admins( subj)
    if Rails.env.production?
      emails = User.where('admin = true and id <> 10').pluck(:email)
      mail(:to => emails, :subject => subj) do |format|
        format.html 
      end
    end
  end

  def changeset_email(dev_id)
    @dev = Develop.find(dev_id)
    @history = get_last_history_item(@dev) 
    @version = @dev.versions.last
    send_mail_to_admins("Изменения в задаче")
  end


  def created_email(dev_id)
    @dev = Develop.find(dev_id)
    @history = get_last_history_item(@dev) 
    @version = @dev.versions.last
    send_mail_to_admins("Создана новая задача")
  end

end
