class DevelopMailer < ActionMailer::Base
  default from: "service@crmpp.ru"
  include CommonHelper
  include DevelopsHelper
  add_template_helper(CommonHelper)
  add_template_helper(DevelopsHelper)

  def send_mail_to_admins(subj, option_id)
    if Rails.env.production? && Rails.application.secrets.host.present?
      admins = User.where(admin: true).ids
      admins = admins & UserOption.where(option_id: option_id).pluck(:user_id) if !option_id.nil?
      emails = User.where(id: admins).pluck(:email)
      mail(:to => emails, :subject => subj) do |format|
        format.html
      end
    end
  end

  def changeset_email(dev_id)
    @dev = Develop.find(dev_id)
    @history = get_last_history_item(@dev)
    @version = @dev.versions.last

    subj = "Изменения в задаче"
    if !@version['object_changes'].nil?
      o = YAML.load(@version['object_changes'])
      if o.keys[0]=='dev_status_id'
        subj = "Задача "+ DevStatus.find(o['dev_status_id'][1]).name
      end
    end
    send_mail_to_admins(subj, 11)
  end


  def created_email(dev_id)
    @dev = Develop.find(dev_id)
    @history = get_last_history_item(@dev)
    @version = @dev.versions.last
    send_mail_to_admins("Создана новая задача", 10)
  end

end
