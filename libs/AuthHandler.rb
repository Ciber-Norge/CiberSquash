def has_access_token?()
  session[:access_token]
end

def safe_urls?(path)
  [
    '/',
    '/auth/google_oauth2/callback',
    '/auth/failure'
  ].include? path
end