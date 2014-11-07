def correct_date?(date)
  date.match(/\d\d\.\d\d\.\d{4}/)
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

def add_player_to_event(id, name)
  event = get_events[id]

  unless full_or_registered?(event, name) then
    event["participating"] << name
    update_event_to_cloudant event
  end
end

def full_or_registered?(event, id)
  event["participating"].size >= event["max"]\
    or event["participating"].include? name
end