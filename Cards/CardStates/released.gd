extends CardState

var target: Node  # This will hold the target node (e.g., DiscardArea, CardDropArea, or another CardUI)
var played: bool

# Counters for stacking cards
var area1_card_count: int = 0


func enter():
	print("Released.")
	played = false

	# Check if we are over a specific target area
	if card_ui.targets.size() > 0:
		Events.tooltip_hide_requested.emit()
		card_ui.card_stats.visible = false
		card_ui.card_stats_tech.visible = false
		card_ui.h_box_container.visible = false
		card_ui.stats_shadow.visible = false
		card_ui.shadow.visible = false
		
		target = card_ui.targets[0]
		print("Target detected:", target.name)
		
		if target.name == "DiscardArea":
			print("Releasing over DiscardArea.")
			card_ui.reset_rotation()
			card_ui.destroy()  # Call destroy function to discard the card
			return
		
		elif target.name == "Area1":
			print("Attempting to play card:", card_ui.name)
			
			# Check play limits in TurnManager
			if card_ui.card.type == Card.Type.POLICY:
				if TurnManager.policy_cards_played_this_round >= TurnManager.max_policy_cards_playable:
					print("Policy card play limit reached.")
					snap_back_to_hand()
					return
				TurnManager.policy_cards_played_this_round += 1
				
			if card_ui.card.type == Card.Type.TECH:
				if TurnManager.tech_cards_played_this_round >= TurnManager.max_tech_cards_playable:
					print("Tech card play limit reached.")
					snap_back_to_hand()
					return
				TurnManager.tech_cards_played_this_round += 1
			
			# Play the card and update the play counters
			if card_ui.play():
				print("Card played successfully:", card_ui.name)
				played = true
				card_ui.reset_rotation()
				snap_to_slot_area1()
				card_ui.used = true  # Synchronize the `used` flag in `CardUI.gd`
				print("Card snapped to slot after play:", card_ui.position)
				return
			else:
				print("Card play failed (insufficient funding):", card_ui.name)
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


func snap_to_slot_area1():
	var base_position = Vector2(720, -1060)
	var main_node = get_tree().root.get_node("Main")
	var y_offset = 35 * main_node.area1_card_count  # Access the counter from Main.gd
	
	card_ui.position = base_position + Vector2(0, y_offset)
	card_ui.z_index = main_node.area1_card_count  # Set z_index based on the count
	card_ui.used = true
	
	main_node.area1_card_count += 1
	print("Card marked as used:", card_ui.used)
	print("Card snapped to position for Area1:", card_ui.position)




func exit():
	Events.tooltip_hide_requested.emit()
	card_ui.targets.clear()
