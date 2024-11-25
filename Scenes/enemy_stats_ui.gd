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


func update_stats(stats: EnemyStats):
	quality.value = stats.quality
	quantity.value = stats.quantity
	popularity.value = stats.popularity
	
	angry.visible = stats.popularity > 0
	unhappy.visible = stats.popularity > 20
	nah.visible = stats.popularity >40
	interestin.visible = stats.popularity >60
	happy.visible = stats.popularity > 80
