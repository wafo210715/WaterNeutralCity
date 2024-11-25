extends CardState


func enter():
	if card_ui.tween_hover and card_ui.tween_hover.is_running():
		card_ui.tween_hover.kill()
	card_ui.tween_hover = card_ui.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	card_ui.tween_hover.tween_property(card_ui, "scale", Vector2(1.2, 1.2), 0.5)
	print("Entered HoverState")

func exit():
	print("Exited HoverState")
	card_ui.reset_rotation()  # Ensure reset upon leaving hover

func on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_mouse"):
		transition_requested.emit(self, CardState.State.CLICKED)
