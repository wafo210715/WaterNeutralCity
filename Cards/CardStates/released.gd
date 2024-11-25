extends CardState

var played: bool

func enter():
	print("Released")
	played = false
	
	if not card_ui.targets.is_empty():
		# Events.tooltip_hide_requested.emit()
		played = true
		# card_ui.play()
		print("play card for targets", card_ui.targets)


func on_input(_event: InputEvent):
	if played:
		return
	
	transition_requested.emit(self, CardState.State.BASE)
