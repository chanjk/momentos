require 'sinatra'
require 'sinatra/reloader'

require_relative 'database_config'

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
