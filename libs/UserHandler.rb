def get_user(uid)
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
  user = get_user(uid)
  user ? user["full_name"] : "ukjent"
end