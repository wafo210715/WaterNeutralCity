class_name UI
extends CanvasLayer

@export var player_stats : PlayerStats : set = _set_player_stats
@onready var hand: Hand = $Hand




func _set_player_stats(value: PlayerStats) -> void:
	player_stats = value
	hand.player_stats = player_stats
