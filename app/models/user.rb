class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  has_many :saved_jobs
  #has_many :active_requests,  class_name: "Request",
  #                            foreign_key: "sent_user_id",
  #                            dependent: :destroy
  #has_many :receivers, through: :active_requests, source: :received_user_id
  #has_many :passive_requests,  class_name: "Request",
  #                             foreign_key: "received_user_id",
  #                             dependent: :destroy
  #has_many :senders, through: :passive_requests, source: :sent_user_id
end
