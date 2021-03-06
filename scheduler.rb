require 'gmail'
require 'net/http'
require 'net/https'
require 'uri'
require 'json'
require 'logger'

require_relative 'models/init'

SCHEDULER_DAY = ENV['SCHEDULER_DAY'] || "monday"
SPORTS_DAY = ENV['SPORTS_DAY'] || "wednesday"
SEND_EMAIL = ENV['SEND_EMAIL'] || false

if SEND_MAIL
  unless GMAIL_USERNAME = ENV['GMAIL_USERNAME']
    raise "You must specify the GMAIL_USERNAME env variable"
  end

  unless GMAIL_PASSWORD = ENV['GMAIL_PASSWORD']
    raise "You must specify the GMAIL_PASSWORD env variable"
  end

  unless MAILING_LIST = ENV['MAILING_LIST'] 
    raise "You must specify the MAILING_LIST env variable"
  end
end

unless SLACK_URL = URI.parse(ENV['SLACK_URL'])
  raise "You must specify the SLACK_URL env variable"
end

def start_task
  now = DateTime.now
  logger.info("Running scheduler at #{now}")
  if now.send(SCHEDULER_DAY + "?") then
    logger.info("It's #{SCHEDULER_DAY}, time to make an event")
    while not now.send(SPORTS_DAY + "?") do
      now = now + 1
    end
    Event.create(date: DateTime.new(now.year, now.month, now.day, 17, 0, 0, 0), max_players: 3)
    if SEND_EMAIL
      logger.info("Sending e-mails to users")
      send_email
    else
      logger.info('Posting to slack')
      post_to_slack
    end
    logger.info('Done with task')
  else
    logger.info("It's not #{SCHEDULER_DAY}...")
  end
end

def post_to_slack
  https = Net::HTTP.new(SLACK_URL.host, SLACK_URL.port)
  https.use_ssl = true
  request = Net::HTTP::Post.new(SLACK_URL.path)
  request.body = {
    "channel": "#squash",
    "username": "SquashBot",
    "attachments": [
                    {
                      "fallback": "Det er squash snart! <https://cibersquash.herokuapp.com/|Meld dere på!>",
                      "color": "good",
                      "title": "Tid for squash!",
                      "text": "God morgen alle squashere!\nNy event er lagt ut på <https://cibersquash.herokuapp.com/|CiberSquash>. Har du lyst å være med og spille bør du melde deg på før det blir fullt!\nHvis du ikke har mulighet til å komme etter at du har meldt deg på, så må du melde deg av før lunsj dagen før, ellers risikerer du å få en prikk. Les mer om prikkesystemet vårt på nettsiden, eller snakk med Pavlo the squashman!",
                      "thumb_url": "http://bbsimg.ngfiles.com/1/23310000/ngbbs4e7909cfd02f8.jpg"
                    }
                   ]}.to_json
  logger.info(https.request(request))
end

def send_email
  Gmail.connect!(GMAIL_USERNAME, GMAIL_PASSWORD) { | gmail | 
    gmail.deliver do
      to MAILING_LIST
      subject ENV['MAIL_SUBJECT']
      text_part do
        content_type 'text/text; charset=UTF-8'
        body ENV['MAIL_BODY_TEXT']
      end
      html_part do
        content_type 'text/html; charset=UTF-8'
        body ENV['MAIL_BODY_HTML']
      end
    end
  }
end

start_task
