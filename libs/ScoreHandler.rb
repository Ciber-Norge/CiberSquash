def save_score_to_event(eventId, player1, score1, player2, score2)
	event = get_event(eventId)
	event["scores"] << generate_score(eventId, player1, score1, player2, score2)
	# maybe move score to it's one table
	update_event event
end

private
def generate_score(eventId, player1, score1, player2, score2)
	{
		id: SecureRandom.uuid,
		event: eventId,
		player1: player1,
		score1: score1,
		player2: player2,
		score2: score2
	}
end

def remove_score_from_event(id, sid)
	event = get_event(id)
	event["scores"].delete_if { | value | value["id"].match sid }

	update_event event
end