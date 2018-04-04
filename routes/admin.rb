class CiberSquash < Sinatra::Base
  namespace '/admin/?' do
    before do
      redirect('/') unless admin?
    end

    get '/?' do
      haml(:admin)
    end

    post '/event/add' do
      max_players = params[:max]
      max_players = 3 if max_players.empty?
      date_string = params[:date]
      time = params[:time]
      date = DateTime.strptime("#{date_string} #{time}", "%d.%m.%Y %H:%M")
      Event.create(date: date, max_players: max_players)

      redirect '/admin'
    end

    get '/edit/:id' do |id|
      haml(:event_edit, locals: {event_id: id})
    end

    post '/edit/:id' do |id|
      event = Event[id]
      max = params[:max]
      event.max_players = max.empty? ? 3 : max
      date_string = params[:date]
      time = params[:time]
      event.date = DateTime.strptime("#{date_string} #{time}", "%d.%m.%Y %H:%M")
      event.save

      redirect '/admin'
    end

    delete '/edit/:id/remove_player/?' do |id|
      event = Event[id]
      redirect('/admin') unless event
      player = Player[params['player_id']]
      redirect('/admin') unless player
      event.remove_player(player)
      redirect('/admin')
    end

    delete '/event/delete/?' do
      event_id = params[:id]
      event = Event[event_id]
      event.delete
      redirect '/admin'
    end
  end
end
