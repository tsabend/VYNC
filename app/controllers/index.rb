get '/' do
  puts "get!"
  erb :index
end

post '/upload' do
  puts "post!"
  puts request.body.read
  puts "-------------"
  puts params
  # website formatting
  # tempfile = params[:content][:file][:tempfile]
  # video_id = Digest::SHA256.file(tempfile.path).hexdigest
  # VideoMessage.create(sender_id: 1, recipient_id: 2, reply_to_id: 0, video_id: video_id)
  # $s3.buckets.first.objects.create(video_id, tempfile)
  # redirect '/'
  "Hey There Cowboy"
end

get '/download' do
  @data = $s3.buckets.first.objects[params[:download]].read
  erb :index
end
