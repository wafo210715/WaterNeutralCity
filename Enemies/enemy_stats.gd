class_name EnemyStats
extends Resource

signal enemy_stats_changed

@export var max_quality := 100
@export var max_quantity := 100
@export var innitial_quality := 20
@export var innitial_quantity := 20

@export var art: Texture

var quality: int : set = set_quality
var quantity: int : set = set_quantity


func set_quality(value: int):
	quality = clampi(value, 0, max_quality)
	enemy_stats_changed.emit()

func quality_changed(amount: int):
	if amount <= 0:
		return
	self.quality += amount



func set_quantity(value: int):
	quantity = clampi(value, 0, max_quantity)
	enemy_stats_changed.emit()

func quantity_changed(amount: int):
	if amount <= 0:
		return
	self.quantity += amount


func create_instance() -> Resource:
	var instance: EnemyStats = self.duplicate()
	instance.quality = innitial_quality
	instance.quantity = innitial_quantity
	return instance
