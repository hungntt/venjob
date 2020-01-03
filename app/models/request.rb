class Request < ApplicationRecord
  belongs_to :sent_user_id, class_name: "User"
  belongs_to :received_user_id, class_name: "User"
  belongs_to :job
end
