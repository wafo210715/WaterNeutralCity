class_name Main
extends Node2D

@onready var hand: Control = $UI/Hand
@onready var discard_area: Area2D = $DiscardArea



func _ready():
	discard_area.connect("body_entered", Callable(self, "_on_body_entered"))


func _on_draw_card_button_pressed() -> void:
	hand.add_card()


func _on_discard_area_body_entered(body):
	if body is CardUI:
		body.destroy()  # Calls destroy() on CardUI when it enters the discard area
