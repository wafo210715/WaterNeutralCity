extends Control

@onready var year_text: Label = $VBoxContainer/YearText
@onready var season_text: Label = $VBoxContainer/SeasonText
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar


@onready var event_card_bg: TextureRect = $EventCardButton/EventCardBG
@onready var event_card_button: Button = $EventCardButton
@onready var event_card_ui: TextureRect = $EventCardButton/EventCardUI
@onready var event_effect_bg: TextureRect = $EventCardButton/EventEffectBG
@onready var h_box_container: HBoxContainer = $EventCardButton/HBoxContainer

@onready var quality_icon: TextureRect = %QualityIcon
@onready var quality_stats: Label = %QualityStats
@onready var quantity_icon: TextureRect = %QuantityIcon
@onready var quantity_stats: Label = %QuantityStats
@onready var popularity_icon: TextureRect = %PopularityIcon
@onready var popularity_stats: Label = %PopularityStats
@onready var funding_icon: TextureRect = %FundingIcon
@onready var funding_stats: Label = %FundingStats

@onready var event_target: Label = $EventTarget

@export var event_card_resources: Array = []  # An array to hold your 5 event card resources
@export var player_stats : PlayerStats

@onready var area_1: Area1 = $"../Area1"
@onready var area_2: Area2 = $"../Area2"
@onready var area_3: Area3 = $"../Area3"
@onready var area_5: Area5 = $"../Area5"
@onready var area_4: Area4 = $"../Area4"

var event_card: Card = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the signal from SeasonManager
	SeasonManager.connect("season_changed", Callable(self, "_on_season_changed"))
	event_card_ui.visible = false
	event_effect_bg.visible = false
	h_box_container.visible = false
	
	# Connect the mouse entered and exited signals to their respective functions
	event_card_ui.connect("mouse_entered", Callable(self, "_on_event_card_area_mouse_entered"))
	event_card_ui.connect("mouse_exited", Callable(self, "_on_event_card_area_mouse_exited"))


func _on_season_changed(current_season: int, current_year: int):
	if current_season == 1:
		season_text.text = "Spring"
	elif current_season == 2:
		season_text.text = "Summer"
	elif current_season == 3:
		season_text.text = "Autumn"
	elif current_season == 4:
		season_text.text = "Winter"
	else:
		season_text.text = "Unknown"
	# Update the year and season labels
	year_text.text = "Year: %d" % current_year
	
	# Update the TextureProgressBar value
	texture_progress_bar.value = current_season
	
	# Print the update for debugging
	print("Season UI updated - Year:", current_year, "Season:", season_text.text)
	var probability = calculate_event_probability(current_year, current_season)
	var random_number = randf_range(0, 1)
	
	# If the event card should be triggered
	if random_number <= probability:
		# Randomly choose an event card (policy, tech, etc.)
		var selected_card = choose_event_card()
		event_card = selected_card
		event_card_ui.texture = selected_card.image
		event_card_ui.visible = true
		if selected_card.funding == 0:
			funding_icon.visible = false
			funding_stats.visible = false
		else:
			funding_icon.visible = true
			funding_stats.visible = true
			funding_stats.text = str(selected_card.funding)
		
		if selected_card.water_quality == 0:
			quality_icon.visible = false
			quality_stats.visible = false
		else:
			quality_icon.visible = true
			quality_stats.visible = true
			quality_stats.text = str(selected_card.water_quality)
		
		if selected_card.water_quantity == 0:
			quantity_icon.visible = false
			quantity_stats.visible = false
		else:
			quantity_icon.visible = true
			quantity_stats.visible = true
			quantity_stats.text = str(selected_card.water_quantity)
		
		if selected_card.popularity == 0:
			popularity_icon.visible = false
			popularity_stats.visible = false
		else:
			popularity_icon.visible = true
			popularity_stats.visible = true
			popularity_stats.text = str(selected_card.popularity)
		
		# Randomly select a target area (area1, area2, area3, etc.)
		var target_area = choose_random_target_area()
		# print("Selected target area:", target_area.name)  # Debug statement
		event_target.text = "Oops! " + str(probability*100) + "% chance of Season Event and it happened in "  + target_area.name
		print(event_target.text)
		# Apply the effects to the selected area and player stats
		selected_card.event_happen([target_area], player_stats)
	else:
		event_card_ui.visible = false
		event_target.text = str(probability*100) + "% chance of Season Event"
		print("Safe! No season event this season.")


# Probability calculation function
func calculate_event_probability(current_year: int, current_season: int) -> float:
	# Start with a base probability
	var probability = 0.25 + (current_year - 1) * 0.1  # Example logic: increase probability each year
	
	# Adjust probability based on the current season
	# Each season gets a different "boost", so Spring is lower, Winter is higher
	var season_boost = 0.0
	if current_season == 1:
		season_boost = 0.05  # Spring gets a small boost
	elif current_season == 2:
		season_boost = 0.1  # Summer gets a bit more
	elif current_season == 3:
		season_boost = 0.15  # Autumn has a higher boost
	elif current_season == 4:
		season_boost = 0.2  # Winter gets the highest seasonal boost
	else:
		season_boost = 0.0  # If for some reason the season is invalid
	
	# Apply the season boost to the base probability
	probability += season_boost
	
	if probability > 1.0:
		probability = 1.0  # Cap the probability at 100%
	return probability


func choose_event_card() -> Card:
	var random_index = randi_range(0, event_card_resources.size() - 1)
	return event_card_resources[random_index]


func choose_random_target_area() -> Node:
	# Randomly select an area (area1 to area5)
	var areas = [area_1, area_2, area_3, area_4, area_5]  # These could be the actual nodes
	var random_index = randi_range(0, areas.size() - 1)
	return areas[random_index]



func _on_event_card_area_mouse_entered() -> void:
	Events.eventcard_tooltip_requested.emit(event_card.id, event_card.tooltip_text)
	h_box_container.visible = true
	event_effect_bg.visible = true


func _on_event_card_area_mouse_exited() -> void:
	Events.tooltip_hide_requested.emit()
	h_box_container.visible = false
	event_effect_bg.visible = false
