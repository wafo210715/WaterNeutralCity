class_name Area1
extends Node2D

@export var enemy_stats: EnemyStats : set = set_enemy_stats

@onready var enemy_stats_ui: EnemyStatsUI = $EnemyStatsUI
@onready var area_1: Area2D = $Area1

var tween: Tween


func _ready():
	await  get_tree().create_timer(2).timeout
	quality_changed(10)
	quantity_changed(20)
	popularity_changed(30)


func set_enemy_stats(value: EnemyStats) -> void:
	enemy_stats = value.create_instance()
	
	if not enemy_stats.enemy_stats_changed.is_connected(update_stats):
		enemy_stats.enemy_stats_changed.connect(update_stats)
	
	update_enemy()



func update_stats() -> void:
	enemy_stats_ui.update_stats(enemy_stats)



func update_enemy() -> void:
	if not enemy_stats is EnemyStats:
		return
	if not is_inside_tree():
		await ready
	update_stats()


func quality_changed(amount: int):
	enemy_stats.quality_changed(amount)


func quantity_changed(amount: int):
	enemy_stats.quantity_changed(amount)


func popularity_changed(amount: int):
	enemy_stats.popularity_changed(amount)



func _on_area_1_area_entered(_area: Area2D) -> void:
	enemy_stats_ui.visible = true
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(area_1, "scale", Vector2(1.3, 1.3), 0.5)


func _on_area_1_area_exited(_area: Area2D) -> void:
	enemy_stats_ui.visible = false
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(area_1, "scale", Vector2(1.0, 1.0), 0.5)
