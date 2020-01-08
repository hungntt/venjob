class Request < ApplicationRecord
  belongs_to :sent_user_id, class_name: "User"
  belongs_to :received_user_id, class_name: "User"
  belongs_to :job

  def send_confirmation_email
    RequestMailer.request_confirmation(self.sent_user_id).deliver_now
  end
end
