class_name PlayerStats
extends Resource

signal player_stats_changed

@export var max_funding: int
@export var max_popularity: int
@export var innitial_funding: int
@export var innitial_popularity: int

@export var max_policy_card: int
@export var max_tech_card: int


@export var policy_card_deck: CardPile
@export var tech_card_deck: CardPile


var num_policy: int : set = set_num_policy
var num_tech: int : set = set_num_tech
var funding: int : set = set_funding
var popularity: int : set = set_popularity



func set_num_policy(value: int):
	num_policy = value
	player_stats_changed.emit()

func reset_num_policy():
	self.num_policy = max_policy_card


func set_num_tech(value: int):
	num_tech = value
	player_stats_changed.emit()

func reset_num_tech():
	self.num_tech = max_tech_card




func set_funding(value: int):
	funding = clampi(value, 0, max_funding)
	player_stats_changed.emit()

func funding_changed(amount: int):
	if amount <= 0:
		return
	self.funding += amount




func set_popularity(value: int):
	popularity = clampi(value, 0, max_popularity)
	player_stats_changed.emit()

func popularity_changed(amount: int):
	if amount <= 0:
		return
	self.popularity += amount



func can_play_policy_card(card: Card)-> bool:
	return funding + card.funding > 0 and num_policy > 0

func can_play_tech_card(card: Card)-> bool:
	return funding + card.funding > 0 and num_tech > 0



func create_instance() -> Resource:
	var instance: PlayerStats = self.duplicate()
	instance.reset_num_policy()
	instance.reset_num_tech()
	instance.funding = innitial_funding
	instance.popularity = innitial_popularity
	return instance
