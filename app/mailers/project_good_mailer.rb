class ProjectGoodMailer < ActionMailer::Base
  default from: "service@crmpp.ru"
  include CommonHelper
  include DatesHelper
  include ActionView::Helpers::UrlHelper
  add_template_helper(CommonHelper)
  add_template_helper(DatesHelper)


  
  def created_email(pg, curr_user)
    @pg = pg
    send_pg_mail("[CRM] Создан новый заказ '#{pg.name}'", 35, curr_user)
  end

  def changeset_email(pg, curr_user)
    @pg = pg
    @history = get_last_history_item(@pg)
    @version = @pg.versions.last
    send_pg_mail("[CRM] Изменен заказ '#{pg.name}'", 36, curr_user)
  end

  private
    def users_emails(option_id, executor_id)
      users_ids = UserOption.users_ids(option_id)
      users_ids << executor_id
      emails = User.actual.where(id: users_ids).pluck(:email)
    end

    def send_pg_mail(subj, option_id, curr_user)
      @current_user = curr_user
      emails = users_emails(option_id, @current_user.id)
      
      if Rails.env.production? && !emails.empty?
      mail(to: emails, subject: subj) do |format|
        format.html
      end
    end

    end
end
