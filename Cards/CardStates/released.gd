extends CardState

var target: Node  # This will hold the target node (e.g., DiscardArea, CardDropArea, or another CardUI)
var played: bool

func enter():
	print("Released.")
	played = false

	# Check if we are over a specific target area
	if card_ui.targets.size() > 0:
		Events.tooltip_hide_requested.emit()
		card_ui.card_stats.visible = false
		card_ui.stats_shadow.visible = false
		
		target = card_ui.targets[0]
		print("Target detected:", target.name)
		
		if target.name == "DiscardArea":
			print("Releasing over DiscardArea.")
			card_ui.reset_rotation()
			card_ui.destroy()  # Call destroy function to discard the card
			return
		
		elif target.name == "Area1":
			# Attempt to play the card
			if card_ui.play():
				played = true
				card_ui.reset_rotation()
				
				# Get the parent node of `Area2D` (which is `Area1`)
				var area_node = target.get_parent()
				if area_node.has_method("snap_card_to_slot"):
					area_node.snap_card_to_slot(card_ui)  # Call `snap_card_to_slot` on the parent node
				else:
					print("Error: Target does not have 'snap_card_to_slot' method.")
					
				return
			else:
				print("Not enough funding, snapping back to hand.")
				snap_back_to_hand()
				return
		
	snap_back_to_hand()


func snap_back_to_hand():
	# Tween to original position and rotation
	var tween = card_ui.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(card_ui, "position", card_ui.original_position, 0.3)
	tween.tween_property(card_ui, "rotation_degrees", card_ui.original_rotation, 0.3)

	# Transition back to Base after snapping back
	tween.finished.connect(func():
		transition_requested.emit(self, CardState.State.BASE)
	)


func exit():
	Events.tooltip_hide_requested.emit()
	card_ui.targets.clear()


# Raycast function to check for the target area when the card is released
func raycast_check_for_target_area() -> Node:
	var space_state = card_ui.get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = card_ui.get_global_mouse_position()
	parameters.collide_with_areas = true
	var result = space_state.intersect_point(parameters)

	if result.size() > 0:
		return result[0].collider.get_parent()  # Return the parent node (e.g., DiscardArea, Area1)

	return null
