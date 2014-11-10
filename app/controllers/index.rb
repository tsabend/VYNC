get '/' do
  puts "get!"
  erb :index
end

get '/allusers' do
  content_type :json
  User.all.to_json
end

get '/videomessages/:user_id/all' do
  content_type :json
  User.find(params[:user_id]).all_chains.to_json
end

get '/videomessages/:user_id/new' do
  content_type :json
  User.find(params[:user_id]).new_chains.to_json
end

get '/videomessages/:user_id/open' do
  content_type :json
  User.find(params[:user_id]).open_chains.to_json
end

get '/videomessages/:user_id/finished' do
  content_type :json
  User.find(params[:user_id]).finished_chains.to_json
end


get '/users/:id' do
  content_type :json
  User.find(params[:id])
  "Message Sent"
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
  # send_file $s3.buckets.first.objects[params["download"]].read, :type => :mov
  # notify("4ac511f6c9dececcdc5cacb1cb53adf992f1e4589949f44911d34e60e5d40486", "Welcome to Chainer!")
end

post "/newuser" do
  "in new user"
  # byebug
  User.create(device_id: params[:deviceToken])
  notify(params[:deviceToken], "Welcome to chainer!")
  # notify("4ac511f6c9dececcdc5cacb1cb53adf992f1e4589949f44911d34e60e5d40486", "Welcome to Chainer!")
end

get "/notetest/:deviceToken" do
  "in note test - to be deleted from production"
  @params = params
  p params[:deviceToken]
  notify(params[:deviceToken], "In note test route")
  erb :notes
end
