extends CardState

func enter():
	if not card_ui.is_node_ready():
		await card_ui.ready
	card_ui.reparent_requested.emit(card_ui)
	card_ui.shadow.visible = false
	card_ui.stats_shadow.visible = false
	card_ui.card_stats.visible = false
	# card_ui.pivot_offset = Vector2.ZERO
	# set_process(true)
	print("Base")

func exit():
	# set_process(false)
	print("Leave Base")


func on_mouse_entered():
	transition_requested.emit(self, CardState.State.HOVER)
