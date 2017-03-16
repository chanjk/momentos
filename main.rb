# require 'pry'
require 'sinatra'
require 'sinatra/cookies'
# require 'sinatra/reloader'

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

def log_in(user_id)
  session[:user_id] = user_id
  redirect "/users/#{user_id}"
end

def log_out
  session.delete(:user_id)
  redirect '/'
end

def add_photo(url, album_id)
  photo = Photo.new(url: url, album_id: album_id)

  if photo.save
    redirect "/albums/#{photo.album.id}"
  else
    erb :photo_new
  end
end

after do
  ActiveRecord::Base.connection.close
end

get '/' do
  @register_failed = (params[:register] == "fail")
  @reason = params[:reason] if @register_failed
  @albums_with_photos = Album.all.select { |album| !album.photos.empty? }
  erb :index
end

get '/search' do
  @users = User.all
  @albums = Album.all
  erb :search
end

get '/albums/new' do
  erb :album_new
end

get '/photos/new' do
  @album = Album.find_by(id: params[:album_id], user_id: current_user.id) if logged_in?
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

get '/users/current/edit' do
  erb :account_edit
end

get '/albums/:id/edit' do
  @album = Album.find(params[:id])
  redirect "/albums/#{@album.id}" unless current_user?(@album.user)
  erb :album_edit
end

post '/session' do
  user = User.find_by(email: params[:email])

  if user && user.authenticate(params[:password])
    log_in(user.id)
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
      log_in(user.id)
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
      add_photo(cookies.delete(:photo_url), album.id)
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
  add_photo(params[params[:method]], params[:album_id])
end

put '/users' do
  user = current_user
  current_password = params[:current_password]
  new_password = params[:new_password]

  if ((current_password.empty? && new_password.empty?) || user.authenticate(current_password)) &&
      (user.email == params[:email] || !User.find_by(email: params[:email]))
    user.email = params[:email]
    user.full_name = if params[:full_name].empty? then nil else params[:full_name] end
    user.password = new_password
    redirect "/users/#{user.id}" if user.save
  end

  redirect back
end

put '/albums/:id' do
  album = Album.find(params[:id])
  album.name = params[:name]
  album.description = params[:description] unless params[:description].empty?

  if album.save
    redirect "/albums/#{album.id}"
  else
    redirect back
  end
end

delete '/session' do
  log_out
end

delete '/users' do
  current_user.destroy
  log_out
end

delete '/albums/:id' do
  album = Album.find(params[:id]).destroy
  redirect "users/#{album.user.id}"
end

delete '/photos/:id' do
  photo = Photo.find(params[:id]).destroy
  redirect "/albums/#{photo.album.id}"
end
