extends CardState

var current_target: Node = null  # Keep track of the currently hovered target area

func enter():
	# Disable input on all other cards while dragging
	var all_cards = card_ui.get_parent().get_children() as Array
	for card in all_cards:
		if card != card_ui:
			card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	# Set the card to follow the mouse
	card_ui.following_mouse = true
	card_ui.reset_hover_rotation()
	set_process(true)  # Enable per-frame updates while dragging
	print("Dragging")


func _process(delta: float) -> void:
	# Update position and rotation while dragging
	card_ui.follow_mouse(delta)
	card_ui.rotate_velocity(delta)
	card_ui.handle_shadow(delta)
	
	# Check for hovering over a target area
	if card_ui.targets.size() > 0:
		var target = card_ui.targets[0]
		if target != current_target:
			# New target detected, start simulation
			current_target = target
			Events.simulation_started.emit(card_ui.card, current_target)
			card_ui.simulate()  # Call the simulate function in card_ui.gd
			print("Simulation started for target:", current_target.name)
	elif current_target != null:
		# No valid target, end simulation
		Events.simulation_ended.emit()
		print("Simulation ended for target:", current_target.name)
		current_target = null



func exit():
	var all_cards = card_ui.get_parent().get_children() as Array
	for card in all_cards:
		card.mouse_filter = Control.MOUSE_FILTER_PASS
	# Stop following the mouse when exiting the Dragging state
	card_ui.following_mouse = false
	set_process(false)
	# Smoothly reset rotation with a tween to ensure the card has no angle
	if card_ui.tween_rot and card_ui.tween_rot.is_running():
		card_ui.tween_rot.kill()
	# Reset scale if needed
	card_ui.reset_scale()
	
	# End simulation if it is still active
	if current_target != null:
		Events.simulation_ended.emit()
		print("Simulation ended for target:", current_target.name)
		current_target = null





func on_gui_input(event: InputEvent):
	# Update position on mouse motion
	if event is InputEventMouseMotion and card_ui.following_mouse:
		card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset

	# End dragging on left-click release
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		transition_requested.emit(self, CardState.State.RELEASED)

	# Right-click cancels dragging and returns to original position
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_released():
		Events.tooltip_hide_requested.emit()
		# Immediately stop following the mouse and disable `_process`
		card_ui.following_mouse = false
		set_process(false)
		
		# card_ui.rotation = 0.0
		
		# Tween back to original position and rotation
		var tween = card_ui.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_property(card_ui, "position", card_ui.original_position, 0.3)
		tween.tween_property(card_ui, "rotation_degrees", card_ui.original_rotation, 0.3)
		
		
		# Transition to Base state once the tween completes
		tween.finished.connect(func():
			transition_requested.emit(self, CardState.State.BASE)
		)
