require 'pry'

require_relative 'database_config'

Dir["models/*.rb"].each { |f| require_relative f }

binding.pry
