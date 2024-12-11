class_name Area3
extends Node2D

@export var enemy_stats: EnemyStats : set = set_enemy_stats


@onready var area_3: Area2D = $Node2D/Area3

@onready var node_2d: Node2D = $Node2D
@onready var enemy_stats_ui: EnemyStatsUI = $EnemyStatsUI
@onready var card_slot: Node2D = $CardSlot
@onready var logo: TextureRect = $Node2D/Area3/Logo
@onready var bg: TextureRect = $Node2D/Area3/BG


var tween: Tween


func _ready():
	print("EnemyStatsUI for Area3:", self, "Instance:", enemy_stats_ui)
	
	Events.connect("simulation_started_3", Callable(self, "_on_simulation_started_3"))
	Events.connect("simulation_ended_3", Callable(self, "_on_simulation_ended_3"))
	
	card_slot.visible = false
	logo.z_index = 1
	enemy_stats_ui.z_index = 1
	card_slot.z_index = 1




func set_enemy_stats(value: EnemyStats) -> void:
	if enemy_stats:
		enemy_stats.enemy_stats_changed.disconnect(update_stats)
	enemy_stats = value.create_instance()
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
	# print("Simulating quality change:", amount)
	enemy_stats_ui.simulate_quality(amount)

func simulate_quantity(amount: int):
	# print("Simulating quantity change:", amount)
	enemy_stats_ui.simulate_quantity(amount)

func simulate_popularity(amount: int):
	# print("Simulating popularity change:", amount)
	enemy_stats_ui.simulate_popularity(amount)

func reset_simulation():
	# print("Resetting simulation UI.")
	enemy_stats_ui.reset_simulation()


func _on_simulation_started_3(card, target):
	enemy_stats_ui.visible = true
	card_slot.visible = true
	if target == self:  # Ensure this Area1 is the target of the simulation
		# print("Simulation started for card:", card.id, "on Area3")
		card.simulate_effects([self])  # Call simulate_effects for this area

func _on_simulation_ended_3():
	reset_simulation()
	enemy_stats_ui.visible = false
	card_slot.visible = false


func get_enemy_stats() -> EnemyStats:
	return enemy_stats


func _on_area_3_mouse_entered() -> void:
	card_slot.visible = true
	enemy_stats_ui.visible = true
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(node_2d, "scale", Vector2(1.3, 1.3), 0.5)
	bg.z_index = 1


func _on_area_3_mouse_exited() -> void:
	card_slot.visible = false
	enemy_stats_ui.visible = false
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(node_2d, "scale", Vector2(1.0, 1.0), 0.5)
	bg.z_index = 0
