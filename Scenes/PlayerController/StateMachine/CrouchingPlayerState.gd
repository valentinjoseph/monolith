class_name CrouchingPlayerState

extends PlayerMovementState

@export var speed : float = 3.0
@export var acceleration: float = 0.1
@export var deceleration : float = 0.25
@export_range(1, 6, 0.1) var crouch_speed : float = 4.0

@onready var crouch_shapecast : ShapeCast3D = %CrouchShapeCast

var released : bool = false

func enter(previous_state) -> void:
	animation.speed_scale = 1.0
	if previous_state.name != "SlidingPlayerState":
		animation.play("crouch", -1.0, crouch_speed)
	elif previous_state.name == "SlidingPlayerState":
		animation.current_animation="crouch"
		animation.seek(1.0, true)

func exit()->void:
	released=false
	
func update(delta):
	player.update_gravity(delta)
	player.update_input(speed,acceleration,deceleration)
	player.update_velocity()
	
	if Input.is_action_just_released("crouch"):
		uncrouch()
	elif Input.is_action_pressed("crouch")==false and released==false:
		released = true
		uncrouch()
		
func uncrouch():
	if crouch_shapecast.is_colliding()==false and Input.is_action_pressed("crouch")==false:
		animation.play("crouch", -1.0, -crouch_speed*1.5, true)
		if animation.is_playing():
			await animation.animation_finished
		transition.emit("IdlePlayerState")
	elif crouch_shapecast.is_colliding()==true:
		await get_tree().create_timer(0.1).timeout
		uncrouch()
