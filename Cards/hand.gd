class_name Hand
extends Control


const CARD = preload("res://Cards/card_ui.tscn")

var dragged_card: CardUI = null

var cards_played_this_turn := 0

# Starting positions for animations
var policy_card_start_position: Vector2 = Vector2(-150, -5)  # Example position for policy cards
var tech_card_start_position: Vector2 = Vector2(1320, -5)    # Example position for tech cards




@export var hand_curve: Curve
@export var rotation_curve: Curve

@export var max_rotation_degrees := 5
@export var x_sep := -10
@export var y_min := 0
@export var y_max := -15




@export var player_stats : PlayerStats

@onready var card_ui := preload("res://Cards/card_ui.tscn")

# Called when the node enters the scene tree for the first time.
# This loop connects a signal (reparent_requested) from each child CardUI node to _on_card_ui_reparent_requested. 
# This is useful for handling reparenting when cards are moved out of the hand (e.g., during drag-and-drop interactions).
func _ready() -> void:
	Events.card_played.connect(_on_card_played)



func animate_card_to_position(card: CardUI, new_position: Vector2, speed: float = 0.4):
	var tween = card.create_tween()
	tween.tween_property(card, "position", new_position, speed)
	tween.finished.connect(func():
		#print("Tween finished for card:", card.name)
		card.position = new_position
		#print("Card position updated to:", card.position)
	)







func add_card(card: Card) -> void:
	var active_policy_count = 0
	var active_tech_count = 0

	# Count the number of active (not used) policy and tech cards
	for child in get_children():
		if child is CardUI and not child.used:
			if child.card.type == Card.Type.POLICY:
				active_policy_count += 1
			elif child.card.type == Card.Type.TECH:
				active_tech_count += 1

	# Check draw limits using TurnManager
	if card.type == Card.Type.POLICY:
		if TurnManager.policy_cards_drawn_this_round >= TurnManager.max_policy_cards_in_hand:
			print("Draw limit reached for policy cards.")
			return
		TurnManager.policy_cards_drawn_this_round += 1

	elif card.type == Card.Type.TECH:
		if TurnManager.tech_cards_drawn_this_round >= TurnManager.max_tech_cards_in_hand:
			print("Draw limit reached for tech cards.")
			return
		TurnManager.tech_cards_drawn_this_round += 1

	# Instantiate the card and set its initial position
	var new_card_ui = card_ui.instantiate()
	add_child(new_card_ui)

	# Set the starting position based on the card type
	if card.type == Card.Type.POLICY:
		new_card_ui.position = policy_card_start_position
	elif card.type == Card.Type.TECH:
		new_card_ui.position = tech_card_start_position

	# Set card properties
	new_card_ui.set_original_position_and_rotation()
	new_card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
	new_card_ui.card = card
	new_card_ui.player_stats = player_stats
	new_card_ui.connect("destroyed", Callable(self, "_on_card_destroyed"))

	# Ensure the card's position is set before updating and animating
	#print("New card added at starting position:", new_card_ui.position)

	# Update the layout and animate the card to the target position
	_update_cards()







# Update layout and position after a card is destroyed
func _on_card_destroyed():
	#print("Hand: Card destroyed, updating layout")  # Print statement in Hand
	# Defer the update to allow the destroyed card to be fully removed from the scene
	call_deferred("_update_cards")


func _on_card_played(_card: Card) -> void:
	cards_played_this_turn += 1


# Returns the number of unused policy and tech cards in hand
func get_unused_card_counts() -> Dictionary:
	var unused_policy_count = 0
	var unused_tech_count = 0

	# Iterate through all children (cards) in the hand
	for child in get_children():
		if child is CardUI and not child.used:
			if child.card.type == Card.Type.POLICY:
				unused_policy_count += 1
			elif child.card.type == Card.Type.TECH:
				unused_tech_count += 1

	return {"policy": unused_policy_count, "tech": unused_tech_count}



func _update_cards(dragged_card = null):
	var num_cards: int = 0
	for card in get_children():
		if card is CardUI and not card.used:
			num_cards += 1

	var all_cards_size: float = CardUI.SIZE.x * num_cards + x_sep * (num_cards - 1)
	var final_x_sep: float = x_sep

	if all_cards_size > size.x:
		final_x_sep = (size.x - CardUI.SIZE.x * num_cards) / (num_cards - 1)
		all_cards_size = float(size.x)

	var offset: float = (size.x - all_cards_size) / 2.0

	var card_index = 0
	for card in get_children():
		if card is CardUI and not card.used:
			var y_multiplier := hand_curve.sample(1.0 / (num_cards - 1) * card_index)
			var rot_multiplier := rotation_curve.sample(1.0 / (num_cards - 1) * card_index)

			if num_cards == 1:
				y_multiplier = 0.0
				rot_multiplier = 0.0

			var final_x: float = offset + CardUI.SIZE.x * card_index + final_x_sep * card_index
			var final_y: float = (y_min + y_max) * y_multiplier
			var final_position = Vector2(final_x, final_y)

			#print("Animating card:", card.name, "to position:", final_position)
			animate_card_to_position(card, final_position)

			card.rotation_degrees = max_rotation_degrees * rot_multiplier
			card.original_position = final_position
			card.original_rotation = card.rotation_degrees

			card_index += 1








func _on_card_ui_reparent_requested(child: CardUI):
	child.disabled = true
	child.reparent(self)
	child.set_deferred("disabled", false)
	
