class CreateFinishedChains < ActiveRecord::Migration
  def change
    create_table :finished_chains do |t|
      t.integer :video_message_start_id
    end
  end
end
