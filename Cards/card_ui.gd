class_name CardUI
extends Button

signal reparent_requested(which_card_ui: CardUI)
signal destroyed  # Define a signal to notify when the card is fully destroyed

@export var angle_x_max: float = 15.0
@export var angle_y_max: float = 15.0
@export var max_offset_shadow: float = 50.0

@export_category("Oscillator")
@export var spring: float = 150.0
@export var damp: float = 10.0
@export var velocity_multiplier: float = 2.0

@export var card_drop_area: Area2D
@export var discard_area: Area2D

const SIZE := Vector2(181,264)


var displacement: float = 0.0
var oscillator_velocity: float = 0.0


var following_mouse: bool = false
var last_pos: Vector2
var velocity: Vector2


var tween_rot: Tween
var tween_hover: Tween
var tween_destroy: Tween


var original_position: Vector2
var original_rotation: float


@onready var card_texture: TextureRect = $CardTexture
@onready var shadow: TextureRect = $Shadow


@onready var collision_shape_2d: CollisionShape2D = $DestroyArea/CollisionShape2D

@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine

@onready var drop_point_detector: Area2D = $DropPointDetector


@onready var targets: Array[Node] = []

func _ready():
	card_state_machine.init(self)
	angle_x_max = deg_to_rad(angle_x_max)
	angle_y_max = deg_to_rad(angle_y_max)
	collision_shape_2d.set_deferred("disabled", true)


func handle_shadow(delta: float) -> void:
	var center: Vector2 = get_viewport_rect().size / 2.0
	var distance: float = global_position.x - center.x
	shadow.position.x = lerp(0.0, -sign(distance) * max_offset_shadow, abs(distance / center.x))


func destroy() -> void:
	card_texture.use_parent_material = true
	if tween_destroy and tween_destroy.is_running():
		tween_destroy.kill()
	tween_destroy = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_destroy.tween_property(material, "shader_parameter/dissolve_value", 0.0, 2.0).from(1.0)
	tween_destroy.parallel().tween_property(shadow, "self_modulate:a", 0.0, 1.0)
	
	tween_destroy.finished.connect(func():
		emit_signal("destroyed")
		print("CardUI: destroyed")  # Print statement to confirm destruction
		queue_free()  # Remove the card from the scene tree after destruction
	)


func follow_mouse(delta: float) -> void:
	if not following_mouse: return
	var mouse_pos: Vector2 = get_global_mouse_position()
	global_position = mouse_pos - (size/2.0)



func rotate_velocity(delta: float) -> void:
	if not following_mouse: return
	var center_pos: Vector2 = global_position - (size/2.0)
	print("Pos: ", center_pos)
	print("Pos: ", last_pos)
	# Compute the velocity
	velocity = (position - last_pos) / delta
	last_pos = position
	
	print("Velocity: ", velocity)
	oscillator_velocity += velocity.normalized().x * velocity_multiplier
	
	# Oscillator stuff
	var force = -spring * displacement - damp * oscillator_velocity
	oscillator_velocity += force * delta
	displacement += oscillator_velocity * delta
	
	rotation = displacement


func reset_transform():
	# Reset rotation
	if tween_rot and tween_rot.is_running():
		tween_rot.kill()
	tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween_rot.tween_property(card_texture.material, "shader_parameter/x_rot", 0.0, 0.5)
	tween_rot.tween_property(card_texture.material, "shader_parameter/y_rot", 0.0, 0.5)

	# Reset scale
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2.ONE, 0.55)


func reset_scale():
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2.ONE, 0.55)


func reset_rotation():
	if tween_rot and tween_rot.is_running():
		tween_rot.kill()
	tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween_rot.tween_property(self, "rotation", 0.0, 0.3)


func set_original_position_and_rotation():
	original_position = position
	original_rotation = rotation_degrees



func _input(event: InputEvent):
	card_state_machine.on_input(event)


func _on_gui_input(event: InputEvent):
	card_state_machine.on_gui_input(event)


func _on_mouse_entered():
	card_state_machine.on_mouse_entered()


func _on_mouse_exited():
	card_state_machine.on_mouse_exited()


func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)
		print("Target entered:", area.name)


func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)
	print("Target exited:", area.name)
