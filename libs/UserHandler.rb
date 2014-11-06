def get_user(uid)
  get_user_from_cloudant uid
end

def save_user(uid, user)
  save_user_to_cloudant uid, user
end