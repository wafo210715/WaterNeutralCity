class_name Main
extends Node2D

@export var player_stats: PlayerStats
@export var card_pile: CardPile

@onready var hand: Control = $UI/Hand
@onready var discard_area: Area2D = $DiscardArea
@onready var policy_tooltip: PolicyTooltip = $UI/PolicyTooltip
@onready var ui: UI = $UI
@onready var player_handler: PlayerHandler = $PlayerHandler

@onready var player: Player = $Player
@onready var enemy_area_1: Area1 = $EnemyArea1




func _ready():
	var new_stats: PlayerStats = player_stats.create_instance()
	ui.player_stats = new_stats
	player.player_stats = new_stats
	discard_area.connect("body_entered", Callable(self, "_on_body_entered"))
	card_pile.shuffle()
	
	game_start(new_stats)
	
	enemy_area_1.connect("card_snapped_to_slot", Callable(self, "_on_card_snapped_to_slot"))


func game_start(stats: PlayerStats) -> void:
	player_handler.game_start(stats)


func _on_card_snapped_to_slot(card_ui: CardUI):
	print("Card snapped to enemy area slot:", card_ui.name)



func _on_draw_card_button_pressed() -> void:
	if not card_pile.empty():
		var card = card_pile.draw_card()
		hand.add_card(card)


func _on_discard_area_body_entered(body):
	if body is CardUI:
		body.destroy()  # Calls destroy() on CardUI when it enters the discard area
