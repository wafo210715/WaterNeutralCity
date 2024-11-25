extends Control

@onready var year_text: Label = $VBoxContainer/YearText
@onready var season_text: Label = $VBoxContainer/SeasonText
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the signal from SeasonManager
	SeasonManager.connect("season_changed", Callable(self, "_on_season_changed"))


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
