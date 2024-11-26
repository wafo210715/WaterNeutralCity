class_name Main
extends Node2D

var area1_card_count: int = 0
var area2_card_count: int = 0


@export var player_stats: PlayerStats

@onready var hand: Control = $UI/Hand
@onready var discard_area: Area2D = $DiscardArea
@onready var policy_tooltip: PolicyTooltip = $UI/PolicyTooltip
@onready var ui: UI = $UI
@onready var player_handler: PlayerHandler = $PlayerHandler
@onready var player_stats_ui: PlayerStatsUI = $Player/PlayerStatsUI


@onready var draw_policy_card_button: Button = $DrawPolicyCardButton
@onready var draw_tech_card_button: Button = $DrawTechCardButton



@onready var next_season_button: Button = $NextSeasonButton

@onready var season_ui: Control = $SeasonUI


func _ready():
	var new_stats: PlayerStats = player_stats.create_instance()
	ui.player_stats = new_stats
	
	# Connect the player_stats_changed signal to the update function in UI
	new_stats.player_stats_changed.connect(player_stats_ui.update_stats)
	
	next_season_button.connect("pressed", Callable(self, "_on_next_season_button_pressed"))
	
	draw_policy_card_button.connect("pressed", Callable(self, "_on_draw_policy_card_button_pressed"))
	draw_tech_card_button.connect("pressed", Callable(self, "_on_draw_tech_card_button_pressed"))
	
	update_season_ui()
	
	discard_area.connect("body_entered", Callable(self, "_on_body_entered"))
	
	game_start(new_stats)


func game_start(stats: PlayerStats) -> void:
	player_handler.game_start(stats)


func update_season_ui() -> void:
	# Manually update the Season UI with the current season and year (in case needed at startup)
	season_ui._on_season_changed(SeasonManager.current_season, SeasonManager.current_year)


func _on_next_season_button_pressed() -> void:
	var unused_counts = hand.get_unused_card_counts()
	var unused_policy_count = unused_counts["policy"]
	var unused_tech_count = unused_counts["tech"]

	# Check if the player has more than 1 unused policy or tech card
	if unused_policy_count > 1 or unused_tech_count > 1:
		print("You have more than 1 unused policy card or more than 1 unused tech card. Please discard extra cards.")
		return

	# If the condition is met, reset the turn and proceed to the next season
	TurnManager.reset_turn()
	# Call the next_season function in SeasonManager when the button is pressed
	SeasonManager.next_season()


# Function to draw a policy card
func _on_draw_policy_card_button_pressed() -> void:
	if not player_stats.policy_card_draw_pile.empty():
		var card = player_stats.policy_card_draw_pile.draw_card()
		hand.add_card(card)
	else:
		print("Policy card draw pile is empty.")

# Function to draw a tech card
func _on_draw_tech_card_button_pressed() -> void:
	if not player_stats.tech_card_draw_pile.empty():
		var card = player_stats.tech_card_draw_pile.draw_card()
		hand.add_card(card)
	else:
		print("Tech card draw pile is empty.")





func _on_discard_area_body_entered(body):
	if body is CardUI:
		body.destroy()  # Calls destroy() on CardUI when it enters the discard area
