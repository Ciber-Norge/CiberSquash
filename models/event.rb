class Event < Sequel::Model
  many_to_many :players, join_table: :participants

  def self.future
    Event.where(Sequel.function(:date, :date) >= Date.today)
  end

  def full?
    players.size >= max_players
  end

  def participating?(player)
    players.include?(player)
  end
end
