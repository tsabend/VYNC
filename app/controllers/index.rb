get '/' do
  puts "get!"
  erb :index
end

post '/upload' do
  puts "post!"
  tempfile = request.params["file"][:tempfile]
  # website formatting
  # tempfile = params[:content][:file][:tempfile]
  # video_id = Digest::SHA256.file(request.params["file"][:filename]).hexdigest
  video_id = request.params["file"][:filename]
  # VideoMessage.create(sender_id: 1, recipient_id: 2, reply_to_id: 0, video_id: video_id)
  $s3.buckets.first.objects.create(video_id, tempfile)
  puts "#{video_id} was uploaded succesfully"
  # redirect '/'
  "Hey There Cowboy"
end

get '/download' do
  "Do you see me?"
  send_file $s3.buckets.first.objects[params["download"]].read, :type => :mov
end
