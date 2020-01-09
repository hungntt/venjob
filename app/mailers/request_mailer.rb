class RequestMailer < ActionMailer::Base
  default from: 'admin@venjob.com'
  layout "mailer"

  def request_confirmation(request)
    @request = request
    mail(to: @request.email, subject: "Request Confirmation")
  end
end
