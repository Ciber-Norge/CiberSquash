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