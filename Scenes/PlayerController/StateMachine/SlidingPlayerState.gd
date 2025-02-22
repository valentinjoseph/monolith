class_name SlidingPlayerState

extends PlayerMovementState

@export var speed : float = 6.0
@export var acceleration: float = 0.1
@export var deceleration : float = 0.25
@export var tilt_amount : float = 0.09
@export_range(1, 6, 0.1) var slide_anim_speed: float = 4.0

@onready var crouch_shapecast : ShapeCast3D = %CrouchShapeCast
@onready var sliding: AudioStreamPlayer3D = $"../../Sounds/Sliding"

func enter(previous_state) -> void:
	set_tilt(player._current_rotation)
	animation.get_animation("sliding").track_set_key_value(5, 0 , player.velocity.length())
	animation.speed_scale=1.0
	animation.play("sliding", -1.0, slide_anim_speed)
	sliding.play()
	
func update(delta):
	player.update_gravity(delta)
	#player.update_input(speed,acceleration,deceleration) #disable to maintain direction while sliding
	player.update_velocity()
	
	if Input.is_action_just_pressed("attack"):
		weapon._attack()
	
func set_tilt(player_rotation) ->void:
	var tilt=Vector3.ZERO
	tilt.z= clamp(tilt_amount * player_rotation, -0.1, 0.1)
	if tilt.z == 0.0:
		tilt.z = 0.05
	animation.get_animation("sliding").track_set_key_value(3,1,tilt)
	animation.get_animation("sliding").track_set_key_value(3,2,tilt)
	
	
	
func finish():
	transition.emit("CrouchingPlayerState")
