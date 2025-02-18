class_name SprintingPlayerState

extends PlayerMovementState

@export var speed : float = 7.0
@export var acceleration: float = 0.1
@export var deceleration : float = 0.25
@export var top_anim_speed : float = 1.6

func enter(previous_state) -> void:
	if animation.is_playing() and animation.current_animation == "jumpend":
		await animation.animation_finished
		animation.play("sprinting", 0.5, 1.0)
	else:
		animation.play("sprinting", 0.5, 1.0)
	

func exit() -> void:
	animation.speed_scale = 1.0	
	
func update(delta):
	player.update_gravity(delta)
	player.update_input(speed,acceleration,deceleration)
	player.update_velocity()
	set_animation_speed(player.velocity.length())
	
	if Input.is_action_just_released("sprint"):
		transition.emit("WalkingPlayerState")
		
	if Input.is_action_just_pressed("crouch") and player.velocity.length() > 6:
		transition.emit("SlidingPlayerState")
		
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		transition.emit("JumpingPlayerState")
		
func set_animation_speed(spd):
	var alpha = remap (spd, 0.0, speed, 0.0, 1.0)
	animation.speed_scale = lerp (0.0, top_anim_speed, alpha)
