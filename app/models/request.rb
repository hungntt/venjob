class Request < ApplicationRecord
  belongs_to :job

  delegate :name, to: :job, prefix: true

  validates :fname, presence: true
  validates :lname, presence: true
  validates :email, presence: true
  validates :cv, presence: true

  def send_confirmation_email
    RequestMailer.request_confirmation(self).deliver_now
  end
end
