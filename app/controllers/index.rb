get '/' do
  puts "get!"
  erb :index
end

post '/upload' do
  puts "post!"
  puts request.body.read
  puts "-------------"
  tempfile = params["movie"] ||= params[:web][:tempfile]
  puts tempfile
  # website formatting
  # tempfile = params[:content][:file][:tempfile]
  # video_id = Digest::SHA256.file(tempfile.path).hexdigest
  video_id = SecureRandom.base64
  # VideoMessage.create(sender_id: 1, recipient_id: 2, reply_to_id: 0, video_id: video_id)
  $s3.buckets.first.objects.create(video_id, tempfile)
  "Hey There Cowboy"
  redirect '/'
end

get '/download' do
  @data = $s3.buckets.first.objects[params[:download]].read
  erb :index
end
