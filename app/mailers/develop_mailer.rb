class DevelopMailer < ActionMailer::Base
  default from: "seventhstar@mail.ru" 
  include CommonHelper
  include DevelopsHelper
  add_template_helper(CommonHelper)
  add_template_helper(DevelopsHelper)

  def changeset_email(dev_id)
    @dev = Develop.find(dev_id)
    puts "dev_id: "+ dev_id.to_s
    @history = get_last_history_item(@dev) 
    @version = @dev.versions.last
    #user = User.first
    admins = User.where({admin: true})
    admins.each do |user|
      if Rails.env.production?
        mail to: user.email, subject: "Изменения в задаче"
      end
    end
  end


  def created_email(dev_id)
    @dev = Develop.find(dev_id)
    #user = User.first
    @history = get_last_history_item(@dev) 
    @version = @dev.versions.last

    admins = User.where({admin: true})
    admins.each do |user|
      if Rails.env.production?
        mail to: user.email, subject: "Создана новая задача"
      end
    end
  end

end
