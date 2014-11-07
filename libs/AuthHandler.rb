def has_access_token?
  session[:access_token]
end

def safe_urls?(path)
  [
    '/',
    '/auth/google_oauth2/callback',
    '/auth/failure'
  ].include? path
end

def is_admin?
  ENV['ADMINS'].split(';').include? session[:uid]
end

def is_logged_in?
  session[:uid]
end

def get_name
  session[:info]["name"]
end