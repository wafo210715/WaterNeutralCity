class_name EnemyStatsUI
extends HBoxContainer

# numbers
@onready var quality: TextureProgressBar = %Quality
@onready var quantity: TextureProgressBar = %Quantity
@onready var popularity: TextureProgressBar = %Popularity

# icons
@onready var happy: TextureRect = %Happy
@onready var interestin: TextureRect = %Interestin
@onready var nah: TextureRect = %Nah
@onready var unhappy: TextureRect = %Unhappy
@onready var angry: TextureRect = %Angry

# Temporary simulation changes
var quality_simulated: int = 0
var quantity_simulated: int = 0
var popularity_simulated: int = 0


func update_stats(stats: EnemyStats):
	quality.value = stats.quality
	quantity.value = stats.quantity
	popularity.value = stats.popularity
	
	angry.visible = stats.popularity > 0
	unhappy.visible = stats.popularity > 20
	nah.visible = stats.popularity >40
	interestin.visible = stats.popularity >60
	happy.visible = stats.popularity > 80

func simulate_quality(amount: int):
	quality_simulated += amount
	quality.value = clamp(quality.value + amount, 0, quality.max_value)
	print("Simulating quality. Current value:", quality.value)

func simulate_quantity(amount: int):
	quantity_simulated += amount
	quantity.value = clamp(quantity.value + amount, 0, quantity.max_value)
	print("Simulating quantity. Current value:", quantity.value)

# Temporarily simulate popularity change
func simulate_popularity(amount: int):
	popularity_simulated += amount
	popularity.value = clamp(popularity.value + amount, 0, popularity.max_value)
	print("Simulating popularity. Current value:", popularity.value)

	# Update icons based on simulated popularity
	angry.visible = popularity.value > 0
	unhappy.visible = popularity.value > 20
	nah.visible = popularity.value > 40
	interestin.visible = popularity.value > 60
	happy.visible = popularity.value > 80

func reset_simulation():
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

	tween.tween_property(quality, "value", quality.value - quality_simulated, 0.5)
	tween.tween_property(quantity, "value", quantity.value - quantity_simulated, 0.5)
	tween.tween_property(popularity, "value", popularity.value - popularity_simulated, 0.5)

	# Reset simulation counters after tween completes
	tween.finished.connect(func():
		quality_simulated = 0
		quantity_simulated = 0
		popularity_simulated = 0
		print("Simulation UI reset completed.")
	)
