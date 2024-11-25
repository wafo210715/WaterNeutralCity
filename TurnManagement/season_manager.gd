extends Node

signal season_changed(current_season: int, current_year: int)

enum Season { SPRING = 1, SUMMER, AUTUMN, WINTER }
var current_season: Season = Season.SPRING
var current_year: int = 1
var max_years: int = 5


func next_season():
	# Increment the season
	current_season += 1
	
	# Loop back to Spring if we go past Winter
	if current_season > Season.WINTER:
		current_season = Season.SPRING
		current_year += 1

	# Check if we have reached the end of the game
	if current_year > max_years:
		# GameManager.check_win_loss()
		print("Game ended after", max_years, "years.")
		return

	# Emit the season changed signal
	emit_signal("season_changed", current_season, current_year)
	print("Season changed to:", current_season, "Year:", current_year)
