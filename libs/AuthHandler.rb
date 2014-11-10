def has_access_token?
  session[:access_token]
end

def safe_urls?(path)
  [
    '/',
    '/credit',
    '/login',
    '/auth/google_oauth2/callback',
    '/auth/facebook/callback',
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
  session[:info]["name"] if session[:info]
end

def get_uid
  session[:uid]
end

def get_info
  session[:info]
end

def get_email
  session[:info]["email"] if session[:info]
end