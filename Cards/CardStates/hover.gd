extends CardState

func enter():
	if card_ui.tween_hover and card_ui.tween_hover.is_running():
		card_ui.tween_hover.kill()
	card_ui.tween_hover = card_ui.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	card_ui.tween_hover.tween_property(card_ui, "scale", Vector2(1.2, 1.2), 0.5)
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
		# Get local mouse position and calculate the rotation based on its position
		var mouse_pos: Vector2 = card_ui.get_local_mouse_position()
		var lerp_val_x: float = remap(mouse_pos.x, 0.0, card_ui.size.x, 0, 1)
		var lerp_val_y: float = remap(mouse_pos.y, 0.0, card_ui.size.y, 0, 1)

		# Calculate target rotations and apply them to the card's shader parameters
		var rot_x: float = rad_to_deg(lerp_angle(-card_ui.angle_x_max, card_ui.angle_x_max, lerp_val_x))
		var rot_y: float = rad_to_deg(lerp_angle(card_ui.angle_y_max, -card_ui.angle_y_max, lerp_val_y))
		card_ui.card_texture.material.set_shader_parameter("x_rot", rot_y)
		card_ui.card_texture.material.set_shader_parameter("y_rot", rot_x)
	
	# Transition to Dragging state only on a full left-click (press and release)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		transition_requested.emit(self, CardState.State.DRAGGING)
