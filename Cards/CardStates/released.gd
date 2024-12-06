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
		#print("Target detected:", target.name)
		
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
				
				
			if card_ui.card.type == Card.Type.TECH:
				if TurnManager.tech_cards_played_this_round >= TurnManager.max_tech_cards_playable:
					print("Tech card play limit reached.")
					snap_back_to_hand()
					return
			
			# Play the card and update the play counters
			if card_ui.play():
				print("Card played successfully:", card_ui.name)
				played = true
				if card_ui.card.type == Card.Type.POLICY:
					TurnManager.policy_cards_played_this_round += 1
				if card_ui.card.type == Card.Type.TECH:
					TurnManager.tech_cards_played_this_round += 1
				card_ui.reset_rotation()
				snap_to_slot_area1()
				card_ui.used = true  # Synchronize the `used` flag in `CardUI.gd`
				print("Card snapped to slot after play:", card_ui.position)
				return
			else:
				print("Card play failed (insufficient funding):", card_ui.name)
				snap_back_to_hand()
				played = false
				card_ui.used = false
				return
		
		elif target.name == "Area2":
			print("Attempting to play card:", card_ui.name)
			
			# Check play limits in TurnManager
			if card_ui.card.type == Card.Type.POLICY:
				if TurnManager.policy_cards_played_this_round >= TurnManager.max_policy_cards_playable:
					print("Policy card play limit reached.")
					snap_back_to_hand()
					return
				
			if card_ui.card.type == Card.Type.TECH:
				if TurnManager.tech_cards_played_this_round >= TurnManager.max_tech_cards_playable:
					print("Tech card play limit reached.")
					snap_back_to_hand()
					return
			
			# Play the card and update the play counters
			if card_ui.play2():
				print("Card played successfully:", card_ui.name)
				played = true
				if card_ui.card.type == Card.Type.POLICY:
					TurnManager.policy_cards_played_this_round += 1
				if card_ui.card.type == Card.Type.TECH:
					TurnManager.tech_cards_played_this_round += 1
				card_ui.reset_rotation()
				snap_to_slot_area2()
				card_ui.used = true  # Synchronize the `used` flag in `CardUI.gd`
				print("Card snapped to slot after play:", card_ui.position)
				return
			else:
				print("Card play failed (insufficient funding):", card_ui.name)
				snap_back_to_hand()
				played = false
				card_ui.used = false
				return
			
		elif target.name == "Area3":
			print("Attempting to play card:", card_ui.name)
			
			# Check play limits in TurnManager
			if card_ui.card.type == Card.Type.POLICY:
				if TurnManager.policy_cards_played_this_round >= TurnManager.max_policy_cards_playable:
					print("Policy card play limit reached.")
					snap_back_to_hand()
					return
				
			if card_ui.card.type == Card.Type.TECH:
				if TurnManager.tech_cards_played_this_round >= TurnManager.max_tech_cards_playable:
					print("Tech card play limit reached.")
					snap_back_to_hand()
					return
			
			# Play the card and update the play counters
			if card_ui.play3():
				print("Card played successfully:", card_ui.name)
				played = true
				if card_ui.card.type == Card.Type.POLICY:
					TurnManager.policy_cards_played_this_round += 1
				if card_ui.card.type == Card.Type.TECH:
					TurnManager.tech_cards_played_this_round += 1
				card_ui.reset_rotation()
				snap_to_slot_area3()
				card_ui.used = true  # Synchronize the `used` flag in `CardUI.gd`
				print("Card snapped to slot after play:", card_ui.position)
				return
			else:
				print("Card play failed (insufficient funding):", card_ui.name)
				snap_back_to_hand()
				played = false
				card_ui.used = false
				return
				
		elif target.name == "Area4":
			print("Attempting to play card:", card_ui.name)
			
			# Check play limits in TurnManager
			if card_ui.card.type == Card.Type.POLICY:
				if TurnManager.policy_cards_played_this_round >= TurnManager.max_policy_cards_playable:
					print("Policy card play limit reached.")
					snap_back_to_hand()
					return
				
			if card_ui.card.type == Card.Type.TECH:
				if TurnManager.tech_cards_played_this_round >= TurnManager.max_tech_cards_playable:
					print("Tech card play limit reached.")
					snap_back_to_hand()
					return
			
			# Play the card and update the play counters
			if card_ui.play4():
				print("Card played successfully:", card_ui.name)
				played = true
				if card_ui.card.type == Card.Type.POLICY:
					TurnManager.policy_cards_played_this_round += 1
				if card_ui.card.type == Card.Type.TECH:
					TurnManager.tech_cards_played_this_round += 1
				card_ui.reset_rotation()
				snap_to_slot_area4()
				card_ui.used = true  # Synchronize the `used` flag in `CardUI.gd`
				print("Card snapped to slot after play:", card_ui.position)
				return
			else:
				print("Card play failed (insufficient funding):", card_ui.name)
				snap_back_to_hand()
				played = false
				card_ui.used = false
				return
				
		elif target.name == "Area5":
			print("Attempting to play card:", card_ui.name)
			
			# Check play limits in TurnManager
			if card_ui.card.type == Card.Type.POLICY:
				if TurnManager.policy_cards_played_this_round >= TurnManager.max_policy_cards_playable:
					print("Policy card play limit reached.")
					snap_back_to_hand()
					return
				
			if card_ui.card.type == Card.Type.TECH:
				if TurnManager.tech_cards_played_this_round >= TurnManager.max_tech_cards_playable:
					print("Tech card play limit reached.")
					snap_back_to_hand()
					return
			
			# Play the card and update the play counters
			if card_ui.play5():
				print("Card played successfully:", card_ui.name)
				played = true
				if card_ui.card.type == Card.Type.POLICY:
					TurnManager.policy_cards_played_this_round += 1
				if card_ui.card.type == Card.Type.TECH:
					TurnManager.tech_cards_played_this_round += 1
				card_ui.reset_rotation()
				snap_to_slot_area5()
				card_ui.used = true  # Synchronize the `used` flag in `CardUI.gd`
				print("Card snapped to slot after play:", card_ui.position)
				return
			else:
				print("Card play failed (insufficient funding):", card_ui.name)
				snap_back_to_hand()
				played = false
				card_ui.used = false
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
	var main_node = get_tree().root.get_node("Main")
	var area1 = main_node.get_node("Area1")  # Access Area1 node
	var card_slot = area1.get_node("CardSlot")  # Access CardSlot node

	# Ensure the card_ui is removed from its current parent
	if card_ui.get_parent():
		card_ui.get_parent().remove_child(card_ui)

	# Reparent the card_ui to the CardSlot node
	card_slot.add_child(card_ui)

	# Set position and update stats
	var base_position = Vector2(0, 0)
	var y_offset = 35 * main_node.area1_card_count  # Offset based on stacking
	card_ui.position = base_position + Vector2(0, y_offset)
	card_ui.z_index = main_node.area1_card_count  # Adjust z_index
	card_ui.used = true

	# Increment stacking counter
	main_node.area1_card_count += 1

	print("Card snapped to position for Area1:", card_ui.position)
	print("Parent of card_ui:", card_ui.get_parent().name)  # Verify parent






func snap_to_slot_area2():
	var main_node = get_tree().root.get_node("Main")
	var area2 = main_node.get_node("Area2")  # Access Area1 node
	var card_slot = area2.get_node("CardSlot")  # Access CardSlot node

	# Ensure the card_ui is removed from its current parent
	if card_ui.get_parent():
		card_ui.get_parent().remove_child(card_ui)

	# Reparent the card_ui to the CardSlot node
	card_slot.add_child(card_ui)

	# Set position and update stats
	var base_position = Vector2(0, 0)
	var y_offset = 35 * main_node.area2_card_count  # Offset based on stacking
	card_ui.position = base_position + Vector2(0, y_offset)
	card_ui.z_index = main_node.area2_card_count  # Adjust z_index
	card_ui.used = true

	# Increment stacking counter
	main_node.area2_card_count += 1

	print("Card snapped to position for Area2:", card_ui.position)
	print("Parent of card_ui:", card_ui.get_parent().name)  # Verify parent



func snap_to_slot_area3():
	var main_node = get_tree().root.get_node("Main")
	var area3 = main_node.get_node("Area3")  # Access Area1 node
	var card_slot = area3.get_node("CardSlot")  # Access CardSlot node

	# Ensure the card_ui is removed from its current parent
	if card_ui.get_parent():
		card_ui.get_parent().remove_child(card_ui)

	# Reparent the card_ui to the CardSlot node
	card_slot.add_child(card_ui)

	# Set position and update stats
	var base_position = Vector2(0, 0)
	var y_offset = 35 * main_node.area3_card_count  # Offset based on stacking
	card_ui.position = base_position + Vector2(0, y_offset)
	card_ui.z_index = main_node.area3_card_count  # Adjust z_index
	card_ui.used = true

	# Increment stacking counter
	main_node.area3_card_count += 1

	print("Card snapped to position for Area3:", card_ui.position)
	print("Parent of card_ui:", card_ui.get_parent().name)  # Verify parent



func snap_to_slot_area4():
	var main_node = get_tree().root.get_node("Main")
	var area4 = main_node.get_node("Area4")  # Access Area1 node
	var card_slot = area4.get_node("CardSlot")  # Access CardSlot node

	# Ensure the card_ui is removed from its current parent
	if card_ui.get_parent():
		card_ui.get_parent().remove_child(card_ui)

	# Reparent the card_ui to the CardSlot node
	card_slot.add_child(card_ui)

	# Set position and update stats
	var base_position = Vector2(0, 0)
	var y_offset = 35 * main_node.area4_card_count  # Offset based on stacking
	card_ui.position = base_position + Vector2(0, y_offset)
	card_ui.z_index = main_node.area4_card_count  # Adjust z_index
	card_ui.used = true

	# Increment stacking counter
	main_node.area4_card_count += 1

	print("Card snapped to position for Area4:", card_ui.position)
	print("Parent of card_ui:", card_ui.get_parent().name)  # Verify parent



func snap_to_slot_area5():
	var main_node = get_tree().root.get_node("Main")
	var area5 = main_node.get_node("Area5")  # Access Area1 node
	var card_slot = area5.get_node("CardSlot")  # Access CardSlot node

	# Ensure the card_ui is removed from its current parent
	if card_ui.get_parent():
		card_ui.get_parent().remove_child(card_ui)

	# Reparent the card_ui to the CardSlot node
	card_slot.add_child(card_ui)

	# Set position and update stats
	var base_position = Vector2(0, 0)
	var y_offset = 35 * main_node.area5_card_count  # Offset based on stacking
	card_ui.position = base_position + Vector2(0, y_offset)
	card_ui.z_index = main_node.area5_card_count  # Adjust z_index
	card_ui.used = true

	# Increment stacking counter
	main_node.area5_card_count += 1

	print("Card snapped to position for Area4:", card_ui.position)
	print("Parent of card_ui:", card_ui.get_parent().name)  # Verify parent


func exit():
	Events.tooltip_hide_requested.emit()
	card_ui.targets.clear()
