class Company < ApplicationRecord
  belongs_to :city
  has_many :jobs
end
