class User < ActiveRecord::Base

  has_many :sent_messages, class_name: "VideoMessage", foreign_key: :sender_id
  has_many :received_messages, class_name: "VideoMessage", foreign_key: :recipient_id
  has_many :finished_chains, through: :video_messages
  has_many :received_notifications
  has_many :chain_updated_notifications
  # validates :device_id, uniqueness: true

  def all_messages(since = 0)
    (received_messages + sent_messages).
    map {|vm| vm.chain}.
    flatten.
    select {|vm| vm.id > since}.
    uniq
  end
end
