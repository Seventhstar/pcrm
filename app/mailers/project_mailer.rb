class ProjectMailer < ActionMailer::Base
  default from: "service@crmpp.ru"
  # include CommonHelper
  # add_template_helper(CommonHelper)

  def reminder_email(prj_id)
    @prj = Project.find(prj_id)
    @subj = 'У проекта '+@prj.address+' подошел срок сдачи!'
    emails = User.where(id: [@prj.executor_id]).pluck(:email)
    if Rails.env.production? && !emails.empty?
      mail(:to => emails, :subject => @subj) do |format|
        format.html
      end
    end
  end

  def overdue_email(prj_id)
    @prj = Project.find(prj_id)
    @subj = 'У проекта '+@prj.address+' истек срок сдачи (не продлен)!'
    emails = User.where(id: [@prj.executor_id]).pluck(:email)
    if Rails.env.production? && !emails.empty?
      mail(:to => emails, :subject => @subj) do |format|
        format.html
      end
    end
  end

end
