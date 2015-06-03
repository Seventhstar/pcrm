class DevelopMailer < ActionMailer::Base
  default from: "seventhstar@mail.ru"
  helper  CommonHelper
  helper DevelopsHelper

  def changeset_email(dev_id)
    @dev = Develop.find(dev_id)
    user = User.first
    if Rails.env.production?
       mail to: user.email, subject: ""
    end
  end
end
