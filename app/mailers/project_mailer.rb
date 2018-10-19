class ProjectMailer < ActionMailer::Base
  default from: "service@crmpp.ru"
  
  def reminder_email(prj_id)
    @prj = Project.find(prj_id)
    @subj = 'У проекта '+@prj.try(:address)+' подошел срок сдачи!'
    
    emails = users_emails(30,@prj.executor_id)
    if Rails.env.production? && !emails.empty? && Rails.application.secrets.host.present?
      mail(to: emails, subject: @subj) do |format|
        format.html
      end
    end
  end

  def overdue_email(prj_id)
    @prj = Project.find(prj_id)
    @subj = 'У проекта '+@prj.try(:address)+' истек срок сдачи (не продлен)!'

    if Date.today.monday?
      emails = users_emails(31,@prj.executor_id)
    else
      emails = @prj.executor.try(:email)
    end

    if Rails.env.production? && emails.present?
      mail(to: emails, subject: @subj) do |format|
        format.html
      end
    end
  end

  private
    def users_emails(option_id, executor_id)
      users_ids = UserOption.users_ids(option_id)
      users_ids << executor_id
      emails = User.where(id: users_ids).pluck(:email)
    end


end
