class CiberSquash < Sinatra::Base
  namespace '/auth/?' do
    get '/:provider/callback' do
      auth = request.env['omniauth.auth']
      uid = auth.uid
      access_token = auth.credentials.token
        
      session[:uid] = uid
      session[:access_token] = access_token
      player = Player.find(uid: uid)
      unless player
        player = Player.create(name: auth.info.name, uid: uid)
      end
      player.email = auth.info.email
      player.avatar_url = auth.info.image
      player.save
      redirect('/')
    end

    get '/failure' do
      begin
        p request.env['omniauth.auth'].to_hash.inspect
      rescue
        p "User could not log in with request #{request}"
        redirect('/')
      end
    end
    
    get '/logout' do
      session.clear
      redirect('/')
    end
  end
end
