require 'yaml'

path = ('/Users/apprentice/Desktop/videotelephone/sinatra/db/seed_data.yaml')
seed_data = YAML.load File.read path

# Users
users = seed_data[:users]
users.each do |attrs|
  User.new(attrs).save(:validate => false)
end
# VideoMessages
video_messages = seed_data[:video_messages]
video_messages.each do |attrs|
  VideoMessage.new(attrs).save(:validate => false)
end
# FinishedChains
finished_chains = seed_data[:finished_chains]
finished_chains.each do |attrs|
  FinishedChain.new(attrs).save(:validate => false)
end
# ReceivedNotifications
received_notifications = seed_data[:received_notifications]
received_notifications.each do |attrs|
  ReceivedNotification.new(attrs).save(:validate => false)
end
# ChainUpdatedNotifications
chain_updated_notifications = seed_data[:chain_updated_notifications]
chain_updated_notifications.each do |attrs|
  ChainUpdatedNotification.new(attrs).save(:validate => false)
end






