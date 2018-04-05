class Player < Sequel::Model
  many_to_many :events, join_table: :participants
end
