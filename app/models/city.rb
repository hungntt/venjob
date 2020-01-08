class City < ApplicationRecord
  extend FriendlyId
  has_many :companies
  has_many :jobs

  validates :slug, presence: true, uniqueness: { case_sensitive: true }

  before_validation :format_slug
  friendly_id :name, use: %i[slugged finders]

  private

  def format_slug
    self.slug = name.to_url
  end
end
