class LeadMailer < ActionMailer::Base
  default from: "service@crmpp.ru"
  include CommonHelper
  include LeadsHelper
  add_template_helper(CommonHelper)
  add_template_helper(LeadsHelper)

  def send_lead_mail( subj, to = nil, user_exclude = nil, only_admins = false )
    
    if Rails.env.production?
      #admins = User.where('admin = true and id <> 1').to_a
      admins = User.where('admin = true' )
    else
      #admins = User.where("admin = 't' and id <> 10").to_a
      admins = User.where(:admin => true)
    end
      
    #p admins.collect(&:name).join(","), @lead.user.name,@lead.ic_user.name


    if !only_admins 
      admins = @lead.user.nil? ? admins : admins | [@lead.user]
      admins = @lead.ic_user.nil? ? admins : admins | [@lead.ic_user]
    end

    if to.nil? 
      
      if !user_exclude.nil?
#        admins.delete(user_exclude)
      end
      puts admins
      

      emails = ""
      if admins.class.name == 'User' 
         emails = admins==user_exclude ? "": admins.email
      else
        emails = admins.collect(&:email).join(",")
      end

    else
      emails = to
    end

    #puts subj, admins, admins[0].try(:name), user_exclude.try(:name),emails
    #puts subj, admins.name, emails, user_exclude.name

    if Rails.env.production? && !emails.empty?
      mail(:to => emails, :subject => subj) do |format|
        format.html 
      end
    end

  end

  def created_email(lead_id, first_comment)
    @first_comment = first_comment
    @lead = Lead.find(lead_id)
    send_lead_mail("[CRM] Новый лид #"+lead_id.to_s)
  end

  def changeset_email(lead_id)
    @lead = Lead.find(lead_id)
    #puts "lead_id: "+ lead_id.to_s
    @history = get_last_history_item(@lead) 
    puts "history:"+ @history.to_s
    @version = @lead.versions.last
    send_lead_mail("[CRM] Изменение информации о лиде")
  end

  def new_owner_email(lead_id)
    @lead = Lead.find(lead_id)
    @version = @lead.versions.last
    send_lead_mail("[CRM] Назначение ответственного",nil,@lead.ic_user,true)
  end

  def you_owner_email(lead_id)
    @lead = Lead.find(lead_id)
    @version = @lead.versions.last
    send_lead_mail("[CRM] Вы назначены ответственным", @lead.ic_user.try(:email))
  end

end
