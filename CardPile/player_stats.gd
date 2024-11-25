class_name PlayerStats
extends Resource

signal player_stats_changed


@export var innitial_funding: int


@export var max_policy_card: int
@export var max_tech_card: int


@export var policy_card_deck: CardPile
@export var policy_card_draw_pile: CardPile
@export var policy_card_discard : CardPile

@export var tech_card_deck: CardPile


var funding: int : set = set_funding


func set_funding(value: int):
	funding = value
	print("Emitting player_stats_changed signal with funding:", funding)
	player_stats_changed.emit()

func funding_changed(amount: int):
	set_funding(self.funding + amount)



func can_play_policy_card(card: Card)-> bool:
	return funding + card.funding > 0 

func can_play_tech_card(card: Card)-> bool:
	return funding + card.funding > 0 



func create_instance() -> Resource:
	var instance: PlayerStats = self.duplicate()
	instance.funding = innitial_funding
	return instance
