class_name CardUI
extends Button

signal reparent_requested(which_card_ui: CardUI)
signal destroyed  # Define a signal to notify when the card is fully destroyed


@export var card: Card : set = _set_card
@export var player_stats: PlayerStats


@export var angle_x_max: float = 15.0
@export var angle_y_max: float = 15.0
@export var shadow_offset_max: float = 10.0

@export var max_offset_shadow: float = 50.0


@export_category("Oscillator")
@export var spring: float = 150.0
@export var damp: float = 10.0
@export var velocity_multiplier: float = 2.0
@export var velocity_threshold: float = 70.0
@export var rotation_decay: float = 0.05
@export var rotation_threshold: float = 0.001


@export var card_drop_area: Area2D
@export var discard_area: Area2D

const SIZE := Vector2(181,264)

var parent_hand: Hand


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
@onready var card_stats: TextureRect = $CardStats
@onready var stats_shadow: TextureRect = $StatsShadow





@onready var quantity_icon: TextureRect = %QuantityIcon
@onready var quantity_stats: Label = %QuantityStats

@onready var quality_icon: TextureRect = %QualityIcon
@onready var quality_stats: Label = %QualityStats

@onready var good_pop_icon: TextureRect = %GoodPopIcon
@onready var good_pop_stats: Label = %GoodPopStats
@onready var bad_pop_icon: TextureRect = %BadPopIcon
@onready var bad_pop_stats: Label = %BadPopStats

@onready var funding_icon: TextureRect = %FundingIcon
@onready var funding_stats: Label = %FundingStats




@onready var collision_shape_2d: CollisionShape2D = $DestroyArea/CollisionShape2D

@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine

@onready var drop_point_detector: Area2D = $DropPointDetector





@onready var targets: Array[Node] = []
@onready var original_index := self.get_index()



func _ready():
	card_state_machine.init(self)
	angle_x_max = deg_to_rad(angle_x_max)
	angle_y_max = deg_to_rad(angle_y_max)
	collision_shape_2d.set_deferred("disabled", true)


# function for HOVER state 
func pick_up_card():
	# Check if a hover tween is already running and kill it if so
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	
	# Create a new hover tween for scaling up
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2(1.2, 1.2), 0.5)


# function for HOVER state, can only apply on card texture
func apply_hover_rotation(mouse_pos: Vector2):
	# Calculate the lerp values based on the mouse position over the card
	var lerp_val_x: float = remap(mouse_pos.x, 0.0, size.x, 0, 1)
	var lerp_val_y: float = remap(mouse_pos.y, 0.0, size.y, 0, 1)

	# Calculate target rotations for x and y based on the lerp values
	var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
	var rot_y: float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))

	# Apply the calculated rotations to the shader parameters
	card_texture.material.set_shader_parameter("x_rot", rot_y)
	card_texture.material.set_shader_parameter("y_rot", rot_x)





# function for DRAGGING state
func handle_shadow(delta: float) -> void:
	var center: Vector2 = get_viewport_rect().size / 2.0
	var distance: float = global_position.x - center.x
	shadow.position.x = lerp(0.0, -sign(distance) * max_offset_shadow, abs(distance / center.x))
	stats_shadow.position.x = lerp(0.0, -sign(distance) * max_offset_shadow, abs(distance / center.x))


# function for DRAGGING state
func follow_mouse(delta: float) -> void:
	if not following_mouse: return
	var mouse_pos: Vector2 = get_global_mouse_position()
	global_position = mouse_pos - (size/2.0)


# function for DRAGGING state
func rotate_velocity(delta: float) -> void:
	if not following_mouse: 
		return
	
	velocity = (position - last_pos) / delta
	if velocity.length() < velocity_threshold:
		return
	
	last_pos = position
	
	# Update oscillator velocity based on the normalized x-component of velocity
	oscillator_velocity += velocity.normalized().x * velocity_multiplier
	
	# Compute the force and update oscillator values
	var force = -spring * displacement - damp * oscillator_velocity
	oscillator_velocity += force * delta
	displacement += oscillator_velocity * delta
	
	# Apply the displacement as rotation
	rotation = displacement





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




# reset this when going from hover to dragging
func reset_hover_rotation():
	card_texture.material.set_shader_parameter("x_rot", 0.0)
	card_texture.material.set_shader_parameter("y_rot", 0.0)


# reset when going from hover to base
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


func get_card_with_highest_z_index(cards: Array) -> CardUI:
	var highest_z_card: CardUI = cards[0]
	var highest_z_index = highest_z_card.z_index

	for i in range(1, cards.size()):
		var current_card: CardUI = cards[i]
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index

	return highest_z_card



func _input(event: InputEvent):
	card_state_machine.on_input(event)


func _on_gui_input(event: InputEvent):
	card_state_machine.on_gui_input(event)


func _on_mouse_entered():
	card_state_machine.on_mouse_entered()


func _on_mouse_exited():
	card_state_machine.on_mouse_exited()



func play() -> bool:
	if not card:
		return false
	
	return card.play(targets, player_stats)


# replace information with card resources
func _set_card(value: Card):
	if not is_node_ready():
		await ready
	
	card = value
	card_texture.texture = card.image
	
	quantity_icon.visible = card.water_quantity != 0
	quantity_stats.visible = card.water_quantity != 0
	if quantity_stats.visible:
		quantity_stats.text = str(card.water_quantity)
		
	quality_icon.visible = card.water_quality != 0
	quality_stats.visible = card.water_quality != 0
	if quality_stats.visible:
		quality_stats.text = str(card.water_quality)
		
	if card.popularity > 0:
		good_pop_icon.visible = true
		good_pop_stats.visible = true
		good_pop_stats.text = str(card.popularity)
		bad_pop_icon.visible = false
		bad_pop_stats.visible = false
	
	if card.popularity < 0:
		bad_pop_icon.visible = true
		bad_pop_stats.visible = true
		bad_pop_stats.text = str(card.popularity)
		good_pop_icon.visible = false
		good_pop_stats.visible = false
	
	if card.popularity == 0:
		bad_pop_icon.visible = false
		bad_pop_stats.visible = false
		good_pop_icon.visible = false
		good_pop_stats.visible = false
	
	funding_icon.visible = card.funding != 0
	funding_stats.visible = card.funding != 0
	if funding_stats.visible:
		funding_stats.text = str(card.funding)





func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)
		print("Target entered:", area.name)


func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)
	print("Target exited:", area.name)
