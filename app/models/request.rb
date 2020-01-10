class Request < ApplicationRecord
  belongs_to :job
  belongs_to :user, class_name: "User", primary_key: :email, foreign_key: :email
  has_one :company, through: :job
  has_one :city, through: :job

  delegate :name, to: :job, prefix: true
  delegate :salary, to: :job, prefix: true
  delegate :name, to: :company, prefix: true
  delegate :name, to: :city, prefix: true

  validates :fname, presence: true
  validates :lname, presence: true
  validates :email, presence: true
  validates :cv, presence: true

  def send_confirmation_email
    RequestMailer.request_confirmation(self).deliver_now
  end
end
