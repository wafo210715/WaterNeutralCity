class_name EnemyStats
extends Resource

signal enemy_stats_changed

@export_category("quality")
@export var max_quality := 100
@export var innitial_quality := 20

@export_category("quantity")
@export var max_quantity := 100
@export var innitial_quantity := 20

@export_category("popularity")
@export var max_popularity:= 100
@export var innitial_popularity:= 20


var quality: int : set = set_quality
var quantity: int : set = set_quantity
var popularity: int : set = set_popularity


func set_quality(value: int):
	quality = clampi(value, 0, max_quality)
	enemy_stats_changed.emit()

func quality_changed(amount: int):
	self.quality += amount



func set_quantity(value: int):
	quantity = clampi(value, 0, max_quantity)
	enemy_stats_changed.emit()

func quantity_changed(amount: int):
	self.quantity += amount


func set_popularity(value: int):
	popularity = clampi(value, 0, max_popularity)
	enemy_stats_changed.emit()

func popularity_changed(amount: int):
	self.popularity += amount



func create_instance() -> Resource:
	var instance: EnemyStats = self.duplicate()
	instance.quality = innitial_quality
	instance.quantity = innitial_quantity
	instance.popularity = innitial_popularity
	return instance
