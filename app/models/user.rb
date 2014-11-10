class User < ActiveRecord::Base
  # Remember to create a migration!
  has_many :sent_messages, class_name: "VideoMessage", foreign_key: :sender_id
  has_many :received_messages, class_name: "VideoMessage", foreign_key: :recipient_id
  has_many :finished_chains, through: :video_messages
  has_many :received_notifications
  has_many :chain_updated_notifications
  # validates :device_id, uniqueness: true

  def all_messages
    received_messages + sent_messages
  end

  def new_chains
    all_messages.
    select {|vm| vm.is_last_link? && !vm.is_finished?}.
    map {|vm| vm.show_chain}
  end

  def open_chains
    all_messages.
    select {|vm| !vm.is_last_link? && !vm.is_finished?}.
    map {|vm| vm.show_chain}
  end

  def finished_chains
    all_messages.
    select {|vm| vm.is_finished?}.
    map {|vm| vm.show_chain}
  end

end
