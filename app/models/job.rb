class Job < ApplicationRecord
  belongs_to :city
  belongs_to :company

  has_many :industry_jobs
  has_many :industries, through: :industry_jobs
  has_many :saved_jobs

  def city_name
    city.name
  end
end
