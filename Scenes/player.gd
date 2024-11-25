class_name Player
extends Node2D

@export var player_stats: PlayerStats : set = set_player_stats

@onready var player_stats_ui: PlayerStatsUI = $PlayerStatsUI


func _ready():
	await  get_tree().create_timer(2).timeout
	funding_changed(2)


func set_player_stats(value: PlayerStats):
	player_stats = value
	
	if player_stats.funding == 0:
		player_stats.set_funding(player_stats.innitial_funding)
	
	if not player_stats.player_stats_changed.is_connected(update_stats):
		player_stats.player_stats_changed.connect(update_stats)
	
	update_player()



func update_player() -> void:
	if not player_stats is PlayerStats:
		return
	if not is_inside_tree():
		await ready
	
	update_stats()


func update_stats() -> void:
	print("update_stats called, funding:", player_stats.funding)
	player_stats_ui.update_stats(player_stats)


func funding_changed(value: int):
	player_stats.funding_changed(value)
