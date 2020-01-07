class Industry < ApplicationRecord
  extend FriendlyId
  has_many :industry_jobs
  has_many :jobs, through: :industry_jobs

  before_save :format_slug
  friendly_id :name, use: %i[slugged finders]

  private

  def format_slug
    self.slug = name.to_url
  end
end
