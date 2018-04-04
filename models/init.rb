require 'sequel'

Sequel::Model.plugin :timestamps

url = ENV['DATABASE_URL'] ? ENV['DATABASE_URL'] : 'postgres://postgres:postgres@localhost:5432/cibersquash'
DB = Sequel.connect(url)

require_relative 'event'
require_relative 'participant'
require_relative 'player'
