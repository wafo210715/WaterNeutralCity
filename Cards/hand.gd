class_name Hand
extends Control


const CARD = preload("res://Cards/card_ui.tscn")

var dragged_card: CardUI = null

var cards_played_this_turn := 0


@export var hand_curve: Curve
@export var rotation_curve: Curve

@export var max_rotation_degrees := 5
@export var x_sep := -10
@export var y_min := 0
@export var y_max := -15

@export var max_cards_in_hand := 4 # Set the maximum number of cards allowed in hand

@export var player_stats : PlayerStats

@onready var card_ui := preload("res://Cards/card_ui.tscn")

# Called when the node enters the scene tree for the first time.
# This loop connects a signal (reparent_requested) from each child CardUI node to _on_card_ui_reparent_requested. 
# This is useful for handling reparenting when cards are moved out of the hand (e.g., during drag-and-drop interactions).
func _ready() -> void:
	Events.card_played.connect(_on_card_played)


# add a card as the hand's child
func add_card(card: Card) -> void:
	# Count only cards that are not marked as `used`
	var active_card_count = 0
	for child in get_children():
		if child is CardUI and not child.used:
			active_card_count += 1
	
	
	if active_card_count >= max_cards_in_hand:
		print("Hand is full, cannot add more cards.")
		return
		
	var new_card_ui = card_ui.instantiate()
	add_child(new_card_ui)
	new_card_ui.set_original_position_and_rotation()  # Set initial position and rotation
	new_card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
	new_card_ui.card = card
	# new_card_ui.parent = self
	new_card_ui.player_stats = player_stats
	new_card_ui.connect("destroyed", Callable(self, "_on_card_destroyed")) # Connect to destroyed signal for layout update
	_update_cards()


# Update layout and position after a card is destroyed
func _on_card_destroyed():
	print("Hand: Card destroyed, updating layout")  # Print statement in Hand
	# Defer the update to allow the destroyed card to be fully removed from the scene
	call_deferred("_update_cards")


func _on_card_played(_card: Card) -> void:
	cards_played_this_turn += 1



func _update_cards(dragged_card = null):
	var num_cards: int = 0
	for card in get_children():
		if card is CardUI and not card.used:
			num_cards += 1
	
	var all_cards_size: float = CardUI.SIZE.x * num_cards + x_sep * (num_cards - 1)
	var final_x_sep: float = x_sep

	# Adjust final_x_sep if cards are overflowing the hand width
	if all_cards_size > size.x:
		final_x_sep = (size.x - CardUI.SIZE.x * num_cards) / (num_cards - 1)
		all_cards_size = float(size.x)  # Ensure all_cards_size is treated as float

	# Center the cards
	var offset: float = (size.x - all_cards_size) / 2.0

	var card_index = 0
	for card in get_children():
		# Skip the dragged card
		if card == dragged_card or (card is CardUI and card.used):
			continue

		var y_multiplier := hand_curve.sample(1.0 / (num_cards - 1) * card_index)
		var rot_multiplier := rotation_curve.sample(1.0 / (num_cards - 1) * card_index)

		if num_cards == 1:
			y_multiplier = 0.0
			rot_multiplier = 0.0

		# Calculate final position and rotation
		var final_x: float = offset + CardUI.SIZE.x * card_index + final_x_sep * card_index
		var final_y: float = (y_min + y_max) * y_multiplier

		card.position = Vector2(final_x, final_y)
		card.rotation_degrees = max_rotation_degrees * rot_multiplier

		# Set original position and rotation
		card.original_position = card.position
		card.original_rotation = card.rotation_degrees

		card_index += 1
		print("Card ", card_index, " Y Multiplier: ", y_multiplier, " Rotation: ", rot_multiplier)



func _on_card_ui_reparent_requested(child: CardUI):
	child.disabled = true
	child.reparent(self)
	child.set_deferred("disabled", false)
	
