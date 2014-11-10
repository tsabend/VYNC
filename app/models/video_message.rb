class VideoMessage < ActiveRecord::Base
  belongs_to :sender, class_name: "User", foreign_key: :user_id
  belongs_to :recipient, class_name: "User", foreign_key: :user_id


  def is_first_message?
    reply_to_id == 0
  end

  def is_finished?
    FinishedChain.find_by(video_message_start_id: self) || FinishedChain.find_by(video_message_start_id: reply_to_id) ? true : false
  end

  def is_last_link?
    self == show_chain.last
  end

  def show_chain
    if is_first_message?
      VideoMessage.where(reply_to_id: id).unshift(self)
    else
      VideoMessage.where(reply_to_id: reply_to_id).unshift(VideoMessage.find(reply_to_id))
    end
  end
end
