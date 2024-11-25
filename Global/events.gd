extends Node


signal card_played(card: Card)
signal card_tooltip_requested(card: Card)
signal tooltip_hide_requested


signal player_hand_drawn
signal player_hand_discarded
signal player_turn_ended

signal simulation_started(card: Card, target: Node)
signal simulation_ended()
