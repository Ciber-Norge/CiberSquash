class Participant < Sequel::Model
  many_to_one :event
  many_to_one :player
end
