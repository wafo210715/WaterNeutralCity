extends Area2D

@onready var dialogue_box: Control = $"../DialogueBox"
var triggered: bool = false
@onready var dimmer_icon: TextureRect = $DimmerIcon
@onready var brighter_icon: TextureRect = $BrighterIcon


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(true)  # Enable input processing

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		triggered = not triggered  # Toggle the triggered state
		dialogue_box.visible = triggered

		# Update icon visibility based on `triggered` state
		dimmer_icon.visible = not triggered
		brighter_icon.visible = triggered
