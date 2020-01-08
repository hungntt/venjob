class IndustryJob < ApplicationRecord
  belongs_to :industry
  belongs_to :job

  delegate :name, to: :industry, prefix: true
  delegate :name, to: :job, prefix: true
end
