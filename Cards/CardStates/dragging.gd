extends CardState



func enter():
	# Set the card to follow the mouse
	card_ui.following_mouse = true
	set_process(true)  # Enable per-frame updates while dragging
	print("Dragging")

func _process(delta: float) -> void:
	# Update position and rotation while dragging
	card_ui.follow_mouse(delta)
	card_ui.rotate_velocity(delta)
	card_ui.handle_shadow(delta)


func exit():
	# card_ui.reset_transform()
	# Stop following the mouse when exiting the Dragging state
	card_ui.following_mouse = false
	set_process(false)
	# Smoothly reset rotation with a tween to ensure the card has no angle
	if card_ui.tween_rot and card_ui.tween_rot.is_running():
		card_ui.tween_rot.kill()
	card_ui.tween_rot = card_ui.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	card_ui.tween_rot.tween_property(card_ui, "rotation", 0.0, 0.3)

	# Reset scale if needed
	card_ui.reset_scale()


func on_gui_input(event: InputEvent):
	# Update position on mouse motion
	if event is InputEventMouseMotion and card_ui.following_mouse:
		card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset

	# End dragging on left-click release
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		transition_requested.emit(self, CardState.State.RELEASED)

	# Right-click cancels dragging and returns to original position
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_released():
		# Immediately stop following the mouse and disable `_process`
		card_ui.following_mouse = false
		set_process(false)
		
		# Tween back to original position and rotation
		var tween = card_ui.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_property(card_ui, "position", card_ui.original_position, 0.3)
		tween.tween_property(card_ui, "rotation_degrees", card_ui.original_rotation, 0.3)

		# Transition to Base state once the tween completes
		tween.finished.connect(func():
			transition_requested.emit(self, CardState.State.BASE)
		)
