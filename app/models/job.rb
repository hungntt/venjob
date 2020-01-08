class Job < ApplicationRecord
  belongs_to :city
  belongs_to :company

  has_many :industry_jobs
  has_many :industries, through: :industry_jobs
  has_many :saved_jobs

  delegate :name, to: :city, prefix: true
  delegate :name, to: :company, prefix: true

  def industry_name_list
    industries.map(&:name)
  end
end
