class_name Area1
extends Node2D

@export var enemy_stats: EnemyStats : set = set_enemy_stats


@onready var area_1: Area2D = $Node2D/Area1

@onready var node_2d: Node2D = $Node2D


@onready var enemy_stats_ui: EnemyStatsUI = $EnemyStatsUI


var tween: Tween


func _ready():
	await  get_tree().create_timer(2).timeout
	quality_changed(10)
	quantity_changed(20)
	popularity_changed(30)
	
	Events.connect("simulation_started", Callable(self, "_on_simulation_started"))
	Events.connect("simulation_ended", Callable(self, "_on_simulation_ended"))






func set_enemy_stats(value: EnemyStats) -> void:
	enemy_stats = value.create_instance()
	
	if not enemy_stats.enemy_stats_changed.is_connected(update_stats):
		enemy_stats.enemy_stats_changed.connect(update_stats)
	
	update_enemy()



func update_stats() -> void:
	enemy_stats_ui.update_stats(enemy_stats)
	print("Enemy stats updated:", enemy_stats)



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


func simulate_quality(amount: int):
	print("Simulating quality change:", amount)
	enemy_stats_ui.simulate_quality(amount)

func simulate_quantity(amount: int):
	print("Simulating quantity change:", amount)
	enemy_stats_ui.simulate_quantity(amount)

func simulate_popularity(amount: int):
	print("Simulating popularity change:", amount)
	enemy_stats_ui.simulate_popularity(amount)

func reset_simulation():
	print("Resetting simulation UI.")
	enemy_stats_ui.reset_simulation()


func _on_simulation_started(card, target):
	if target == self:  # Ensure this Area1 is the target of the simulation
		print("Simulation started for card:", card.id, "on Area1")
		card.simulate_effects([self])  # Call simulate_effects for this area

func _on_simulation_ended():
	reset_simulation()



func _on_area_1_mouse_entered() -> void:
	enemy_stats_ui.visible = true
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(node_2d, "scale", Vector2(1.3, 1.3), 0.5)


func _on_area_1_mouse_exited() -> void:
	enemy_stats_ui.visible = true
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(node_2d, "scale", Vector2(1.0, 1.0), 0.5)
