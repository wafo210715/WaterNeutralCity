class_name TechTooltip
extends Control

@onready var margin_container: MarginContainer = %MarginContainer
@onready var card_name: Label = %CardName
@onready var card_description: RichTextLabel = %CardDescription

var tween: Tween
var original_position: Vector2

enum TooltipState { HIDDEN, SHOWING, SHOWN, HIDING }
var state: TooltipState = TooltipState.HIDDEN

func _ready() -> void:
	Events.techcard_tooltip_requested.connect(show_tooltip)
	Events.tooltip_hide_requested.connect(hide_tooltip)
	margin_container.visible = false
	original_position = position

func show_tooltip(text: String, description: String) -> void:
	# Only show the tooltip if it is currently hidden or hiding
	if state == TooltipState.SHOWING or state == TooltipState.SHOWN:
		return

	state = TooltipState.SHOWING
	if tween:
		tween.kill()

	margin_container.visible = true
	card_name.text = text
	card_description.text = description

	var target_position = original_position + Vector2(380, 0)
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", target_position, 0.5).finished.connect(func():
		state = TooltipState.SHOWN
		#print("Tooltip shown.")
	)

func hide_tooltip() -> void:
	# Only hide the tooltip if it is currently shown or showing
	if state == TooltipState.HIDING or state == TooltipState.HIDDEN:
		return

	state = TooltipState.HIDING
	if tween:
		tween.kill()

	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", original_position, 0.5).finished.connect(func():
		margin_container.visible = false
		state = TooltipState.HIDDEN
		#print("Tooltip hidden.")
	)
