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

# Track permanent and simulated changes
var permanent_quality: int = 0
var permanent_quantity: int = 0
var permanent_popularity: int = 0

var quality_simulated: int = 0
var quantity_simulated: int = 0
var popularity_simulated: int = 0

var stats: EnemyStats = null  # Linked stats instance

# Update permanent stats
func update_stats(stats: EnemyStats):
	permanent_quality = stats.quality
	permanent_quantity = stats.quantity
	permanent_popularity = stats.popularity

	_apply_stats_to_ui()
	print("Permanent stats updated: Quality:", permanent_quality, "Quantity:", permanent_quantity, "Popularity:", permanent_popularity)


# Simulate quality change
func simulate_quality(amount: int):
	quality_simulated += amount
	_apply_stats_to_ui()
	print("Simulating quality. Current simulated value:", quality_simulated)

# Simulate quantity change
func simulate_quantity(amount: int):
	quantity_simulated += amount
	_apply_stats_to_ui()
	print("Simulating quantity. Current simulated value:", quantity_simulated)

# Simulate popularity change
func simulate_popularity(amount: int):
	popularity_simulated += amount
	_apply_stats_to_ui()
	print("Simulating popularity. Current simulated value:", popularity_simulated)


# Reset only the simulated changes
func reset_simulation():
	quality_simulated = 0
	quantity_simulated = 0
	popularity_simulated = 0
	_apply_stats_to_ui()
	print("Simulation reset. Stats UI back to permanent values.")


# Apply both permanent and simulated stats to the UI
func _apply_stats_to_ui():
	quality.value = permanent_quality + quality_simulated
	quantity.value = permanent_quantity + quantity_simulated
	popularity.value = permanent_popularity + popularity_simulated

	# Update icons based on the final value (permanent + simulated)
	_update_icons()


# Update icons based on popularity thresholds
func _update_icons():
	angry.visible = popularity.value > 0
	unhappy.visible = popularity.value > 20
	nah.visible = popularity.value > 40
	interestin.visible = popularity.value > 60
	happy.visible = popularity.value > 80
