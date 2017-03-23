class ProjectMailer < ActionMailer::Base
  default from: "service@crmpp.ru"
  include CommonHelper

  add_template_helper(CommonHelper)


  def reminder_email(user, prj_today, prj_tomorrow)
       @l_today =leads_today
       @l_tomorrow = leads_tomorrow
  	  subj = '[CRM] Напоминание о событии'
  	  email = User.find(user).email
  	  if Rails.env.production? && !email.empty?
      mail(:to => email, :subject => subj) do |format|
        format.html 
      end
    end
  end

end
