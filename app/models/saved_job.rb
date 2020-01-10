class SavedJob < ApplicationRecord
  belongs_to :job
  belongs_to :user
  has_one :company, through: :job
  has_one :city, through: :job

  delegate :name, to: :job, prefix: true
  delegate :salary, to: :job, prefix: true
  delegate :name, to: :company, prefix: true
  delegate :name, to: :city, prefix: true
end
