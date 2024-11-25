extends CardState

func enter():
	card_ui.shadow.visible = true
	card_ui.stats_shadow.visible = true
	card_ui.card_stats.visible = true
	card_ui.pick_up_card()
	print("Hover")
 

# Called when we exit the hover state
func exit():
	print("Exited HoverState")


# Transition back to Base when mouse leaves the card area
func on_mouse_exited():
	transition_requested.emit(self, CardState.State.BASE)
	card_ui.reset_transform() # Ensure reset upon leaving hover

# Transition to Dragging on mouse click
func on_gui_input(event: InputEvent):
	# Handle rotation effect when mouse moves over the card
	if event is InputEventMouseMotion and not card_ui.following_mouse:
		# Call the new function to handle rotation based on mouse position
		card_ui.apply_hover_rotation(card_ui.get_local_mouse_position())
	
	# Transition to Dragging state only on a full left-click (press and release)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		transition_requested.emit(self, CardState.State.DRAGGING)
