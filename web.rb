require 'sinatra'
require 'rubygems'
require 'haml'
require 'json'
require 'rest_client'
require 'securerandom'
require 'omniauth'
require 'omniauth-google-oauth2'
require 'omniauth-facebook'

require_relative 'libs/DatabaseHandler'
require_relative 'libs/EventHandler'
require_relative 'libs/UserHandler'
require_relative 'libs/AuthHandler'

unless CLOUDANT_URL = ENV['CLOUDANT_URL']
  raise "You must specify the CLOUDANT_URL env variable"
end

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

$DB_URL = ENV['CLOUDANT_URL'] + '/squash'
$eventsId = '81a97d7a3192b7ea47b6f3acc37da3bd'
$usersId = '26566edcbb3782c35347e1cea5608f2a'

use Rack::Session::Cookie, :secret => ENV['RACK_COOKIE_SECRET']

use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], {}
  provider :facebook, ENV['FACEBOOK_ID'], ENV['FACEBOOK_SECRET'], :scope => 'email,read_stream'
end

before do
  # TODO add admin checks
  unless safe_urls? request.path_info
    unless has_access_token?
      redirect '/login'
    end
  end
end

get '/' do
  haml :index
end

get '/credit' do
  haml :credit
end

get '/login' do
  haml :login
end

get '/minside' do
  haml :profile, :locals => {:info => session[:info]}
end

post '/minside' do
  info = session[:info]
  info["racket"] = params["racket"]
  save_user(session[:uid], info)

  redirect '/minside'
end

post '/blimed' do
  eventId = params["id"]
  if params.has_key? "join" then
    add_player_to_event eventId, get_uid, get_info
  elsif params.has_key? "leave" then
    remove_player_from_event eventId, get_uid
  end

  redirect '/'
end

get '/admin' do
  if is_admin? then
    haml :admin
  else
    redirect '/'
  end
end

post '/admin' do
  if is_admin? then
    date = params[:date]
    if correct_date? date then
      add_event! date
  	  redirect '/'
    else
  	  redirect '/admin'
    end
  else
    redirect '/'
  end
end

# Sign in
get '/auth/:provider/callback' do
  content_type 'text/plain'
  begin
    authJson = request.env['omniauth.auth']
    session[:uid] = authJson["uid"]
    session[:access_token] = authJson["credentials"]["token"]
    # save or update user...keep that info fresh!
    save_user(session[:uid], authJson["info"])
    session[:info] = authJson["info"] # always use latest
    redirect '/'
  rescue
    # TODO
    "No Data"
  end
end

get '/auth/failure' do
  content_type 'text/plain'
  request.env['omniauth.auth'].to_hash.inspect rescue "No Data"
end