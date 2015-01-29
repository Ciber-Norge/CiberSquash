# -*- coding: utf-8 -*-
require_relative 'web.rb'

require 'gmail'

SCHEDULER_DAY = ENV['SCHEDULER_DAY'] || "monday"

unless GMAIL_USERNAME = ENV['GMAIL_USERNAME']
  raise "You must specify the GMAIL_USERNAME env variable"
end

unless GMAIL_PASSWORD = ENV['GMAIL_PASSWORD']
  raise "You must specify the GMAIL_PASSWORD env variable"
end

unless MAILING_LIST = ENV['MAILING_LIST']
  raise "You must specify the MAILING_LIST env variable"
end

def start_task
  now = DateTime.now
  p "Running scheduler at #{now}"
  if now.send(SCHEDULER_DAY + "?") then
    p "It's #{SCHEDULER_DAY}, time to make an event"
    add_event! DateTime.new(now.year, now.month, now.day, 18, 0, 0, 0)
    p "Sending e-mails to users"
    send_email()
    p "Done with task"
  else
    p "It's not #{SCHEDULER_DAY}..."
  end
end

def send_email
  Gmail.connect!(GMAIL_USERNAME, GMAIL_PASSWORD) { | gmail | 
    gmail.deliver do
      to MAILING_LIST
      subject "Squash: Ny event er ute!"
      text_part do
        content_type 'text/text; charset=UTF-8'
        body "God morgen alle squashere!\n\nNy event er lagt ut på http://cibersquash.herokuapp.com/. Har du lyst å være med og spille bør du melde deg på før det blir fullt!\n\nHvis du ikke har mulighet til å komme etter at du har meldt deg på, så må du melde deg av før lunsj dagen før, ellers risikerer du å få en prikk. Les mer om prikkesystemet vårt på nettsiden, eller snakk med Njaal Gjerde.\n\nMvh\nSquashbotten"
      end
      html_part do
        content_type 'text/html; charset=UTF-8'
        body "<p>God morgen alle squashere!</p><p>Ny event er lagt ut på <a href=\"http://cibersquash.herokuapp.com/\">CiberSquash</a>. Har du lyst å være med og spille bør du melde deg på før det blir fullt!</p><p>Hvis du ikke har mulighet til å komme etter at du har meldt deg på, så må du melde deg av før lunsj dagen før, ellers risikerer du å få en prikk. Les mer om prikkesystemet vårt på nettsiden, eller snakk med Njaal Gjerde.</p><p>Mvh<br>Squashbotten</p>"
      end
    end
  }
end

start_task
