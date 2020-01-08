class RequestMailer < ActionMailer::Base
  def request_confirmation(user)
    @user = user
    mail to: user.email, subject: "Request Confirmation"
  end
end
