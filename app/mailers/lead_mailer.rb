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
    
    if Rails.env.production?
      #admins = User.where('admin = true and id <> 1').to_a
      admins = User.where('admin = true' ).ids
    else
      #admins = User.where("admin = 't' and id <> 10").to_a
      admins = User.where(:admin => true).ids
    end
      
    #p admins.collect(&:name).join(","), @lead.user.name,@lead.ic_user.name
    p "admins: "+ admins.to_s
    p "id: "+id.to_s
    if !id.nil?
      opt_users = User.joins(:options).where('option_id = ?',id).ids
      p "opt_users: " + opt_users.to_s
      admins = admins & opt_users
      p "admins: " + admins.to_s

    end


    if !only_admins 
      admins = @lead.user.nil? ? admins : admins | [@lead.user.id]
      admins = @lead.ic_user.nil? ? admins : admins | [@lead.ic_user_id]
    end

    if to.nil? 
      admins = User.find(admins)
      emails = ""
      if admins.class.name == 'User' 
         emails = admins==user_exclude ? "": admins.email
      else
        emails = admins.collect(&:email).join(",")
      end
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
    #puts "lead_id: "+ lead_id.to_s
    @history = get_last_history_item(@lead) 
    puts "history:"+ @history.to_s
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
