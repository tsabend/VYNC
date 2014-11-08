class CreateReceivedNotifications < ActiveRecord::Migration
  def change
    create_table :received_notifications do |t|
      t.integer :user_id
      t.integer :video_message_start_id
    end
  end
end
