require 'active_record'

options = {
  adapter: "postgresql",
  database: "momentos"
}

ActiveRecord::Base.establish_connection( ENV['DATABASE_URL'] || options)
