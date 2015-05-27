class DevelopMailer < ActionMailer::Base
  default from: "seventhstar@mail.ru"

  def changeset_email()
    user = User.first
    if Rails.env.production?
       mail to: user.email, subject: ""
    end
  end
end
