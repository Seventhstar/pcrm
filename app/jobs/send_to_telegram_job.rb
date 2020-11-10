class SendToTelegramJob < ApplicationJob
  queue_as :default

  def perform(lead)
    chat_id = lead.ic_user.try(:telegram)
    if !chat_id.nil? && chat_id.length >0
      token = Rails.application.secrets['telegram'][:bot]
      token = Rails.application.secrets['telegram']['bot'] if token.nil?
      bot = Telegram::Bot::Client.new(token)

      if Rails.env.development?
        keyboard = {inline_keyboard: [[{text: "Перейти", url: 'ya.ru'}]]}
      else
        keyboard = {inline_keyboard: [[{text: "Перейти", url: edit_lead_path(lead)}]]}
      end
      markup = JSON.parse(keyboard.to_json)

      phone = lead&.phone.present? ? "Телефон: #{lead.phone}" : nil
      email = lead&.email.present? ? "E-mail: #{lead.email}": nil

      text = %Q["Вы назначены ответственным
Лид: [##{lead.id}] #{lead.try(:address)}
ФИО: #{lead.fio}"
#{phone}
#{email}
Информация:
#{lead.info}"]
              
      bot.send_message chat_id: chat_id, text: text, reply_markup: markup
    end
  end
end
