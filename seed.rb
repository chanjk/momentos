require 'pry'

require_relative 'database_config'

Dir["models/*.rb"].each { |f| require_relative f }

user = User.new(email: "test@account.com", full_name: "John Smith")
user.password = "test"
user.save

album = Album.create(name: "Japan trip", description: "Holiday in wintry Tokyo", user_id: user.id)

photo = Photo.create(url: "https://media-cdn.tripadvisor.com/media/photo-s/07/15/f1/8b/shibuya-crossing.jpg", album_id: album.id)

# binding.pry
