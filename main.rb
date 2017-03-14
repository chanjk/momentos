require 'pry'
require 'sinatra'
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
  erb :index
end

get '/albums/new' do
  erb :album_new
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

post '/session' do
  user = User.find_by(email: params[:email])

  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    # redirect "/users/#{user.id}"
    redirect back
  else
    redirect '/'
  end
end

post '/albums' do
  album = Album.new(name: params[:name], description: params[:description], user_id: current_user.id)

  if album.save
    redirect "/users/#{current_user.id}"
  else
    erb :album_new
  end
end

delete '/session' do
  session[:user_id] = nil
  redirect '/'
end
