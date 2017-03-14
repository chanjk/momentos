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

get '/users/:id' do
  erb :account
end

get '/albums/:id' do
  erb :album
end

get '/photos/:id' do
  erb :photo
end

post '/users' do
  user = User.find_by(email: params[:email])

  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect "/users/#{user.id}"
  else
    redirect '/'
  end
end
