require 'sinatra'
require 'rubygems'
require 'haml'
require 'json'
require 'rest_client'


unless CLOUDANT_URL = ENV['CLOUDANT_URL']
  raise "You must specify the CLOUDANT_URL env variable"
end

$DB_URL = "#{ENV['CLOUDANT_URL']}"

get '/' do
  haml :index
end
