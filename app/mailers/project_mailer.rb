class ProjectMailer < ActionMailer::Base
  default from: "service@crmpp.ru"
  include CommonHelper

  add_template_helper(CommonHelper)


  def reminder_email(user, prj_today, prj_tomorrow)
       @p_today = prj_today
       @p_tomorrow = prj_tomorrow
  	  subj = '[CRM] Напоминание о проектах'
      to = [user,5]
  	  # email = User.find(user).email
      emails = User.where(id: to).pluck(:email)
  	  if Rails.env.production? && !emails.empty?
        mail(:to => emails, :subject => subj) do |format|
        format.html 
      end
    end
  end

end
