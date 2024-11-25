extends CardState

var previous_hovered_card: CardUI = null

func enter():
	print("Entering Hover State.")
	if previous_hovered_card and previous_hovered_card != card_ui:
		previous_hovered_card.z_index = 0
		previous_hovered_card.shadow.visible = false
		previous_hovered_card.stats_shadow.visible = false
		previous_hovered_card.card_stats.visible = false
		previous_hovered_card.card_stats_tech.visible = false
		previous_hovered_card.h_box_container.visible = false

	card_ui.shadow.visible = true
	card_ui.stats_shadow.visible = true
	card_ui.h_box_container.visible = true
	if card_ui.card.type == Card.Type.POLICY:
		card_ui.card_stats.visible = true
		card_ui.card_stats_tech.visible = false
	elif card_ui.card.type == Card.Type.TECH:
		card_ui.card_stats.visible = false
		card_ui.card_stats_tech.visible = true

	card_ui.pick_up_card()
	card_ui.z_index = 100  # Bring the hovered card to the front
	previous_hovered_card = card_ui
	print("Card picked up. Setting z_index to 100 for:", card_ui.name)

func exit():
	if card_ui.z_index != 0:
		print("Exited HoverState. Resetting z_index to 0 for:", card_ui.name)
		card_ui.z_index = 0
	else:
		print("Exited HoverState. z_index already set to 0 for:", card_ui.name)



func on_mouse_exited():
	Events.tooltip_hide_requested.emit()
	transition_requested.emit(self, CardState.State.BASE)
	if card_ui.z_index != 0:
		print("Mouse exited. Resetting z_index to 0 for:", card_ui.name)
		card_ui.z_index = 0
	card_ui.reset_transform()

func on_gui_input(event: InputEvent):
	if event is InputEventMouseMotion and not card_ui.following_mouse:
		card_ui.apply_hover_rotation(card_ui.get_local_mouse_position())

	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		transition_requested.emit(self, CardState.State.DRAGGING)
