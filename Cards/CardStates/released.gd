extends CardState

var target: Node  # This will hold the target node (e.g., DiscardArea, CardDropArea, or another CardUI)
var played: bool

func enter():
	print("Released.")
	played = false

	# Check if we are over a specific target area
	if card_ui.targets.size() > 0:
		target = card_ui.targets[0]
		print("Target detected:", target.name)
		
		if target.name == "DiscardArea":
			print("Releasing over DiscardArea.")
			card_ui.destroy()  # Call destroy function to discard the card
			return
		
		elif target.name == "Area1":
			# Attempt to play the card
			if card_ui.play():
				played = true
				card_ui.reset_rotation()
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
	card_ui.targets.clear()
