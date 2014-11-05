def get_events_from_cloudant
  JSON.parse(RestClient.get($DB_URL + "/#{$eventsId}"))["events"]
end

def add_event_to_cloudant(event)
  jdata = JSON.parse(RestClient.get($DB_URL + "/#{$eventsId}"))
  jdata["events"][event[:id]] = event
  save_to_cloudant(jdata.to_json)
end

def update_event_to_cloudant(event)
  jdata = JSON.parse(RestClient.get($DB_URL + "/#{$eventsId}"))
  jdata["events"][event["id"]] = event
  save_to_cloudant(jdata.to_json)
end

def save_to_cloudant(json)
  begin
    @respons =  RestClient.post("#{$DB_URL}/", json, {:content_type => :json, :accept => :json})
    if @respons["ok"] then
      p "OK"
    else
      # something bad :\
    end
  rescue => e
    p e.response
    # inform someone
  end
end