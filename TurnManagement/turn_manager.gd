extends Node

# Draw limits per round
var policy_cards_drawn_this_round: int = 0
var tech_cards_drawn_this_round: int = 0

# Play limits per round
var policy_cards_played_this_round: int = 0
var tech_cards_played_this_round: int = 0

# Maximum limits
var max_policy_cards_in_hand: int = 4
var max_tech_cards_in_hand: int = 5
var max_policy_cards_playable: int = 2
var max_tech_cards_playable: int = 3

# Reset all counters at the start of a new round
func reset_turn():
	policy_cards_drawn_this_round = 0
	tech_cards_drawn_this_round = 0
	policy_cards_played_this_round = 0
	tech_cards_played_this_round = 0
	print("TurnManager: All counters reset for the new round.")
