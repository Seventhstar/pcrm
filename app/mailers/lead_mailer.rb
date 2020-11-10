class LeadMailer < ActionMailer::Base
  default from: "service@crmpp.ru"
  include CommonHelper
  include LeadsHelper
  include ActionView::Helpers::UrlHelper
  add_template_helper(CommonHelper)
  add_template_helper(LeadsHelper)

  def reminder_email(user, leads_today, leads_tomorrow)
    @l_today = leads_today
    @l_tomorrow = leads_tomorrow
    subj = '[CRM] Напоминание о событии'
    email = User.find(user).email
    if Rails.env.production? && !email.empty?
      mail(to: email, subject: subj) do |format|
        format.html
      end
    end
  end

  def send_lead_mail(subj, to = nil, user_exclude = nil, only_admins = false, option_id = nil)

    if Rails.env.production? && Rails.application.secrets.host.present?      
      if to.present?
        emails = to
      else
        admins = User.admins.ids
        subscribers = UserOption.users_ids(option_id) if !option_id.nil?
        receivers = admins & subscribers

        if !only_admins
          receivers << @lead.user.id if !@lead.user.nil?
          receivers << @lead.ic_user_id if !@lead.ic_user.nil?
        end

        emails = User.actual.where(id: receivers).pluck(:email)
        emails.delete(user_exclude)
      end

      if Rails.env.production? && !emails.empty?
        mail(to: emails, subject: subj) do |format|
          format.html
        end
      end
    end
  end

  def created_email(lead_id, first_comment)
    @first_comment = first_comment
    @lead = Lead.find(lead_id)
    send_lead_mail("[CRM] Новый лид ##{lead_id}", nil, nil, false, 1)
  end

  def changeset_email(lead_id)
    @lead = Lead.find(lead_id)
    @history = get_last_history_item(@lead)
    @version = @lead.versions.last
    send_lead_mail("[CRM] Изменение информации о лиде", nil, nil, false, 2)
  end

  def new_owner_email(lead_id)
    @lead = Lead.find(lead_id)
    @version = @lead.versions.last
    send_lead_mail("[CRM] Назначение ответственного", nil, @lead.ic_user, true, 3)
  end

  def you_owner_email(lead_id)
    @lead = Lead.find(lead_id)
    @version = @lead.versions.last
    send_lead_mail("[CRM] Вы назначены ответственным", @lead.ic_user.try(:email))

    SendToTelegramJob.perform_later @lead
    # chat_id = @lead.ic_user.try(:telegram)
    # if !chat_id.nil? && chat_id.length >0
    #   token = Rails.application.secrets['telegram'][:bot]
    #   token = Rails.application.secrets['telegram']['bot'] if token.nil?
    #   bot = Telegram::Bot::Client.new(token)

    #   if Rails.env.development?
    #     keyboard = {inline_keyboard: [[{text: "Перейти", url: 'ya.ru'}]]}
    #   else
    #     keyboard = {inline_keyboard: [[{text: "Перейти", url: edit_polymorphic_url(@lead)}]]}
    #   end
    #   markup = JSON.parse(keyboard.to_json)

    #   lnk = ['[#', @lead.id, ']'].join
    #   text = ["Вы назначены ответственным",
    #           "Лид: #{lnk} #{@lead.try(:address)}",
    #           "ФИО: #{@lead.fio}",
    #           @lead.try(:phone).present? ? "Телефон: #{@lead.phone}" : nil,
    #           @lead.try(:email).present? ? "E-mail: #{@lead.email}": nil ,
    #           "Информация:",
    #           "#{raw(@lead.info)}"].compact.join("\n")
              
    #   # bot.send_message chat_id: chat_id, text: text, reply_markup: markup
    # end
  end

end
