require 'sinatra'
require 'rubygems'
require 'haml'
require 'json'
require 'rest_client'
require 'securerandom'

require_relative 'libs/EventHandler'

unless CLOUDANT_URL = ENV['CLOUDANT_URL']
  raise "You must specify the CLOUDANT_URL env variable"
end

$DB_URL = "#{ENV['CLOUDANT_URL']}" + "/squash"
$eventsId = "81a97d7a3192b7ea47b6f3acc37da3bd"

get '/' do
  haml :index
end

post '/blimed' do
  eventId = params[:id]
  name = params[:name]
  if name.length > 2 then
    add_player_to_event eventId, name
  end

  redirect '/'
end

get '/admin' do
  haml :admin
end

post '/admin' do
	date = params[:date]
  if correct_date? date then
  	add_event! date
  	redirect '/'
  else
  	redirect '/admin'
  end
end
