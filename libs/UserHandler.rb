def get_user_by(uid)
  get_user_from_cloudant uid
end

def update_user(user)
  save_user_to_cloudant user["id"], user
end

def save_user(uid, user)
  save_user_to_cloudant uid, user
end

def get_users
  get_users_from_cloudant
end

def get_scores_for_users
  scores = []
  get_events.each do | key, value |
    value["scores"].each do | score |
      if score["player1"].match get_uid or\
        score["player2"].match get_uid then
        scores << score
      end
    end
    
  end
  scores
end

def get_user_first_name(uid)
  user = get_user_by uid
  user ? user["full_name"] : "ukjent"
end

# info
def init_user_info(uid)
  info = get_user_info_from_cloudant(uid) || add_user_info(uid)
  session[:info] = info
end

def get_user_info(uid)
  session[:info] || get_user_info_from_cloudant(uid)
end

def add_user_info(uid)
  info = {:racket => "", :scores => []}
  save_user_info_to_cloudant uid, info
  info
end

def save_user_info(uid, info)
  save_user_info_to_cloudant uid, info
end
