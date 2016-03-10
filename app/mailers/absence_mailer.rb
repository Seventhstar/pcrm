class AbsenceMailer < ActionMailer::Base
  default from: "service@crmpp.ru" 
  include CommonHelper
  include DevelopsHelper
  add_template_helper(CommonHelper)
#  add_template_helper(DevelopsHelper)

  def send_mail_to( subj, curr_user = nil )
    if Rails.env.production?
      emails = User.where('admin = true and id <> 10').pluck(:email)
      if !curr_user.nil? && curr_user.id != @abs.user_id
        emails << @abs.user.email
      end 
      mail(:to => emails, :subject => subj) do |format|
        format.html 
      end
    end
  end

  def changeset_email(a_id,curr_user)
    @abs = Absence.find(a_id)
    @history = get_last_history_item(@abs) 
    @version = @abs.versions.last
    send_mail_to("Изменения в отсутствии",curr_user)
  end


  def created_email(a_id, curr_user)
    @abs = Absence.find(a_id)
    @history = get_last_history_item(@abs) 
    @version = @abs.versions.last
    send_mail_to("Создано отсутствие",curr_user)
  end

end
