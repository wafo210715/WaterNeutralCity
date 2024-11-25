class_name Area1
extends Node2D

@export var enemy_stats: EnemyStats : set = set_enemy_stats

@onready var enemy_stats_ui: EnemyStatsUI = $EnemyStatsUI
@onready var area_1: Area2D = $Area1
@onready var card_slot_area_1: Area2D = $CardSlotArea1


var tween: Tween

var slot_y_offset: float = 0.0
var slot_increment_y: float = 20.0  # Increment in Y for stacking

signal card_snapped_to_slot(card_ui: CardUI)


# func _ready():
	# await  get_tree().create_timer(2).timeout
	# quality_changed(10)
	# quantity_changed(20)
	# popularity_changed(30)



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


func snap_card_to_slot(card_ui: CardUI):
	# Apply effects before reparenting
	print("Applying effects before reparenting the card.")

	# Set a deferred call to handle the reparenting after the effects are applied
	call_deferred("_reparent_card_to_slot", card_ui)


func _reparent_card_to_slot(card_ui: CardUI):
	# Ensure the card is still visible and set the z_index explicitly
	card_ui.z_index = 200  # Set a high z_index to keep the card visible

	# Reparent the card to `CardSlotArea1`
	card_ui.get_parent().remove_child(card_ui)
	card_slot_area_1.add_child(card_ui)

	# Set the card's position relative to `CardSlotArea1` and update the Y offset
	card_ui.position = card_slot_area_1.position + Vector2(0, slot_y_offset)
	slot_y_offset += slot_increment_y

	print("Card reparented to slot area and positioned at:", card_ui.position)
	emit_signal("card_snapped_to_slot", card_ui)



func _on_area_1_area_entered(_area: Area2D) -> void:
	enemy_stats_ui.visible = true
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(area_1, "scale", Vector2(1.3, 1.3), 0.5)


func _on_area_1_area_exited(_area: Area2D) -> void:
	enemy_stats_ui.visible = false
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(area_1, "scale", Vector2(1.0, 1.0), 0.5)
