require 'dotenv/load' unless ENV['RACK_ENV'] == 'production'
require 'logger'
require 'omniauth-google-oauth2'
require 'omniauth-facebook'
require 'sinatra/base'
require 'sinatra/namespace'

unless GOOGLE_SECRET = ENV['GOOGLE_SECRET']
  raise "You must specify the GOOGLE_SECRET env variable"
end

unless GOOGLE_KEY = ENV['GOOGLE_KEY']
  raise "You must specify the GOOGLE_KEY env variable"
end

unless FACEBOOK_ID = ENV['FACEBOOK_ID']
  raise "You must specify the FACEBOOK_ID env variable"
end

unless FACEBOOK_SECRET = ENV['FACEBOOK_SECRET']
  raise "You must specify the FACEBOOK_SECRET env variable"
end

require_relative 'models/init'
require_relative 'web'
require_relative 'routes/init'

run CiberSquash.new
