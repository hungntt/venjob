class City < ApplicationRecord
  extend FriendlyId
  has_many :companies
  has_many :jobs

  before_save :format_slug
  friendly_id :name, use: %i[slugged finders]

  private

  def format_slug
    self.slug = name.to_url
  end
end
