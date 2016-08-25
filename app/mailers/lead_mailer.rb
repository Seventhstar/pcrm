class LeadMailer < ActionMailer::Base
  default from: "service@crmpp.ru"
  include CommonHelper
  include LeadsHelper
  add_template_helper(CommonHelper)
  add_template_helper(LeadsHelper)

  def reminder_email(user, leads_today, leads_tomorrow)
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

  def send_lead_mail( subj, to = nil, user_exclude = nil, only_admins = false, id = nil )
    
    admins = User.where(admin: true).ids
    admins = admins & UserOption.where(option_id: id).pluck(:user_id) if !id.nil?
    
    if !only_admins    
      admins << @lead.user.id if !@lead.user.nil?
      admins << @lead.ic_user_id if !@lead.ic_user.nil? 
    end

    if to.nil?
      emails = User.where(id: admins).pluck(:email) 
      emails.delete(user_exclude)
    else
      emails = to
    end

    if Rails.env.production? && !emails.empty?
      mail(:to => emails, :subject => subj) do |format|
        format.html 
      end
    end

  end

  def created_email(lead_id, first_comment)
    @first_comment = first_comment
    @lead = Lead.find(lead_id)
    send_lead_mail("[CRM] Новый лид #"+lead_id.to_s,nil,nil,false,1)
  end

  def changeset_email(lead_id)
    @lead = Lead.find(lead_id)
    @history = get_last_history_item(@lead) 
    @version = @lead.versions.last
    send_lead_mail("[CRM] Изменение информации о лиде",nil,nil,false,2)
  end

  def new_owner_email(lead_id)
    @lead = Lead.find(lead_id)
    @version = @lead.versions.last
    send_lead_mail("[CRM] Назначение ответственного",nil,@lead.ic_user,true,3)
  end

  def you_owner_email(lead_id)
    @lead = Lead.find(lead_id)
    @version = @lead.versions.last
    send_lead_mail("[CRM] Вы назначены ответственным", @lead.ic_user.try(:email))
  end

end
