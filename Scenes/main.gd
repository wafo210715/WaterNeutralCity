extends Node2D

@onready var hand: Control = $UI/Hand

func _on_draw_card_button_pressed() -> void:
	hand.add_card()


func _on_discard_card_button_pressed() -> void:
	hand.discard_card()
