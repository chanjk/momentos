require 'pry'
require 'sinatra'
require 'sinatra/cookies'
require 'sinatra/reloader'

require_relative 'database_config'
require_relative 'models/album'
require_relative 'models/photo'
require_relative 'models/user'

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end

  def current_user?(user)
    current_user == user
  end

  def logged_in?
    !!current_user
  end
end

after do
  ActiveRecord::Base.connection.close
end

get '/' do
  @register_failed = (params[:register] == "fail")
  @reason = params[:reason] if @register_failed
  erb :index
end

get '/albums/new' do
  erb :album_new
end

get '/photos/new' do
  @album = Album.find_by(id: params[:album_id], user_id: current_user.id)
  erb :photo_new
end

get '/users/:id' do
  @owner = User.find(params[:id])
  erb :account
end

get '/albums/:id' do
  @album = Album.find(params[:id])
  erb :album
end

get '/photos/:id' do
  @photo = Photo.find(params[:id])
  erb :photo
end

get '/albums/:id/edit' do
  @album = Album.find(params[:id])
  erb :album_edit
end

post '/session' do
  user = User.find_by(email: params[:email])

  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect "/users/#{user.id}"
  else
    redirect '/'
  end
end

post '/users' do
  if !User.find_by(email: params[:email])
    user = User.new(email: params[:email])
    user.full_name = params[:full_name] unless params[:full_name].empty?
    user.password = params[:password]

    if user.save
      redirect "/session?email=#{user.email}&password=#{user.password}", 307
    else
      redirect '/?register=fail&reason=error'
    end
  end

  redirect '/?register=fail&reason=taken'
end

post '/albums' do
  album = Album.new(name: params[:name], description: params[:description], user_id: current_user.id)

  if album.save
    if !cookies[:photo_url]
      redirect "/users/#{current_user.id}"
    else
      redirect "/photos?album_id=#{album.id}", 307
    end
  else
    erb :album_new
  end
end

post '/albums/new' do
  photo_url = params[params[:method]]

  if photo_url && !photo_url.empty?
    cookies[:photo_url] = photo_url
    redirect '/albums/new'
  else
    erb :photo_new
  end
end

post '/photos' do
  if request.referrer.match('/albums') && cookies[:photo_url]
    photo_url = cookies.delete(:photo_url)
  else
    photo_url = params[params[:method]]
  end

  photo = Photo.new(url: photo_url, album_id: params[:album_id])

  if photo.save
    redirect "/albums/#{photo.album.id}"
  else
    erb :photo_new
  end
end

put '/albums/:id' do
  album = Album.find(params[:id])
  album.name = params[:name]
  album.description = params[:description] unless params[:description].empty?

  if album.save
    redirect "/albums/#{params[:id]}"
  else
    redirect "/albums/#{params[:id]}/edit"
  end
end

delete '/session' do
  session.delete(:user_id)
  redirect '/'
end
