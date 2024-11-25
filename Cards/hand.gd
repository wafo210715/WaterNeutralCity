class_name Hand
extends Control


const CARD = preload("res://Cards/card_ui.tscn")

@export var hand_curve: Curve
@export var rotation_curve: Curve

@export var max_rotation_degrees := 5
@export var x_sep := -10
@export var y_min := 0
@export var y_max := -15


# Called when the node enters the scene tree for the first time.
# This loop connects a signal (reparent_requested) from each child CardUI node to _on_card_ui_reparent_requested. 
# This is useful for handling reparenting when cards are moved out of the hand (e.g., during drag-and-drop interactions).
func _ready() -> void:
	for child in get_children():
		var card_ui := child as CardUI
		card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)

# add a card as the hand's child
func add_card():
	var new_card = CARD.instantiate()
	add_child(new_card)
	_update_cards()


func discard_card():
	if get_child_count() < 1:
		return
	
	var child := get_child(-1)
	child.reparent(get_tree().root)
	child.queue_free()
	_update_cards()


func _update_cards():
	# get the number of cards
	var cards := get_child_count()
	# calculate all cards size including space/separation between cards
	var all_cards_size := CardUI.SIZE.x * cards + x_sep * (cards - 1)
	var final_x_sep: float = x_sep
	
	# check if cards are overflowing the hand width, final_x_sep should be negative (making the card overlaping each other)
	if all_cards_size > size.x:
		final_x_sep = (size.x - CardUI.SIZE.x * cards) / (cards - 1)
		# make the combined width equal to hand width, otherwiser, the offset will bug
		all_cards_size = size.x
	
	# make the cards centered
	var offset := (size.x - all_cards_size) / 2
	
	
	for i in range(cards):
		var card := get_child(i)
		var y_multiplier := hand_curve.sample(1.0 / (cards-1) * i)
		var rot_multiplier := rotation_curve.sample(1.0 / (cards-1) * i)
		
		if cards == 1:
			y_multiplier = 0.0
			rot_multiplier = 0.0
		
		var final_x: float = offset + CardUI.SIZE.x * i + final_x_sep * i
		var final_y: float = (y_min + y_max) * y_multiplier
		
		card.position = Vector2(final_x, final_y)
		card.rotation_degrees = max_rotation_degrees * rot_multiplier
		print("Card ", i, " Y Multiplier: ", y_multiplier, " Rotation: ", rot_multiplier)


func _on_card_ui_reparent_requested(child: CardUI):
	# child.disabled = true
	child.reparent(self)
