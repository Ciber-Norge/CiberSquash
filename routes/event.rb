class CiberSquash < Sinatra::Base
  namespace '/event/?' do
    before do
      redirect('/') unless logged_in?
    end

    post '/join/?' do
      event_id = params["event_id"]
      event = Event[event_id]
      redirect('/') unless event
      player = Player.find(uid:  session[:uid])
      redirect('/') if event.participating?(player)
      event.add_player(player)
      redirect '/'
    end

    post '/leave/?' do
      event_id = params["event_id"]
      event = Event[event_id]
      redirect('/') unless event
      player = Player.find(uid:  session[:uid])
      event.remove_player(player)      
      redirect('/')
    end
  end
end
