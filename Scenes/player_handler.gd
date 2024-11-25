class_name PlayerHandler
extends Node

@export var hand: Hand

var player: PlayerStats

func game_start(player_stats: PlayerStats) -> void:
	player = player_stats
	player.policy_card_draw_pile = player.policy_card_deck.duplicate(true)
	player.policy_card_draw_pile.shuffle()
	player.policy_card_discard = CardPile.new()
	start_turn()


func start_turn() -> void:
	draw_card()


func draw_card() -> void:
	hand.add_card(player.policy_card_draw_pile.draw_card())
	Events.player_hand_drawn.emit()
