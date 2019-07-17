class AbsenceMailer < ActionMailer::Base
  default from: "service@crmpp.ru"
  include CommonHelper
  include DevelopsHelper
  add_template_helper(CommonHelper)

  def send_mail_to(subj, curr_user = nil, user_option = nil)
    if Rails.env.production? && Rails.application.secrets.host.present?

      if user_option.nil?
        emails = User.admins.not_anna.pluck(:email)
      else
        emails = User.joins(:options).actual.where('admin = true and option_id = ?', user_option).pluck(:email)
      end

      emails << @abs.user.email if !curr_user.nil? && curr_user.id != @abs.user_id && !@abs.user.nil?
      return if emails.nil? || emails.empty?

      mail(to: emails, subject: subj) do |format|
        format.html
      end
    end
  end

  def changeset_email(a_id, curr_user)
    @abs = Absence.find(a_id)
    @history = get_last_history_item(@abs)
    @version = @abs.versions.last
    send_mail_to("Изменения в отсутствии", curr_user, 21)
  end


  def created_email(a_id, curr_user)
    @abs = Absence.find(a_id)

    if @abs.reason_id == 3 && @abs.project_id == 0
      return
    end
    # p "@abs", @abs
    @history = get_last_history_item(@abs)
    @version = @abs.versions.last
    send_mail_to("Создано отсутствие", curr_user, 20)
  end

end
