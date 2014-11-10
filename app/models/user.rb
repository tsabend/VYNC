class User < ActiveRecord::Base
  # Remember to create a migration!
  has_many :sent_messages, class_name: "VideoMessage", foreign_key: :sender_id
  has_many :recieved_messages, class_name: "VideoMessage", foreign_key: :recipient_id
  has_many :finished_chains, through: :video_messages
  has_many :received_notifications
  has_many :chain_updated_notifications
  # validates :device_id, uniqueness: true

end
