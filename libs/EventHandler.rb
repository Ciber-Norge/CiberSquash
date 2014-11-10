def correct_date?(date)
  date.match(/\d\d\.\d\d\.\d{4}/) if date
end

def add_event!(date)
  add_event_to_cloudant(generate_event(date))
end

def get_events
  # no cach yet
  get_events_from_cloudant
end

def generate_event(date)
  {
    id: SecureRandom.uuid,
    date: date,
    max: 7,
    participating: []
  }
end

def add_player_to_event(eventId, uid, info)
  name = info["name"]
  email = info["email"]
  event = get_events[eventId]

  unless event_full? event or registered?(event["participating"], name) then
    event["participating"] << { "name" => name, "id" => uid, "email" => email }
    update_event_to_cloudant event
  end
end

def remove_player_from_event(id, uid)
  event = get_events[id]

  unless event_full? event then
    event["participating"].delete_if { | value | value["id"].match uid }
  end
  
  update_event_to_cloudant event
end

def event_full?(event)
  event["participating"].size >= event["max"] if event
end

def registered?(participants, name)
  if name.nil? then return false end
    
  participants.each do | value |
    if value["name"].match name then
      return true
    end
  end

  false
end