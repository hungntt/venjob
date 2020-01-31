require 'carrierwave/orm/activerecord'
class Request < ApplicationRecord

  belongs_to :job
  belongs_to :user, class_name: "User", primary_key: :email, foreign_key: :email
  has_one :company, through: :job
  has_one :city, through: :job
  has_many :industry_jobs, through: :job
  has_many :industries, through: :industry_jobs

  delegate :name, to: :job, prefix: true
  delegate :salary, to: :job, prefix: true
  delegate :name, to: :company, prefix: true
  delegate :name, to: :city, prefix: true


  validates :fname, :lname, :email, presence: true

  mount_uploader :cv, FileUploader


  def send_confirmation_email
    RequestMailer.request_confirmation(self).deliver_now
  end

  def self.to_csv(requests)
    CSV.generate do |csv|
      csv << ["Job name", "Company name", "Applicant name", "Applicant email", "Applied at"]

      requests.each do |request|
        csv << [request.job_name, request.company_name, request.fname + " " + request.lname, request.email, request.created_at]
      end
    end
  end
end
