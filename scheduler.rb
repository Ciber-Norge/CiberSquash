require 'rest_client'

require_relative 'libs/DatabaseHandler'
require_relative 'libs/EventHandler'

def start_task
  add_event! new DateTime
  p "Sending e-mails to users"
end

start_task
