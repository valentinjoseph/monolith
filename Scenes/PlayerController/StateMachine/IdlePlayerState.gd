class_name IdlePlayerState

extends PlayerMovementState

@export var speed : float = 5.0
@export var acceleration: float = 0.1
@export var deceleration : float = 0.25

func enter(previous_state) -> void:
	if animation.is_playing() and animation.current_animation == "jumpend":
		await animation.animation_finished
		animation.pause()
	else:
		animation.pause()
	
	
func update(delta):
	player.update_gravity(delta)
	player.update_input(speed,acceleration,deceleration)
	player.update_velocity()
	
	weapon.sway_weapon(delta, true)
	
	if Input.is_action_just_pressed("crouch") and player.is_on_floor():
		transition.emit("CrouchingPlayerState")
		
	if player.velocity.length()>0.0 and player.is_on_floor():
		transition.emit("WalkingPlayerState")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		transition.emit("JumpingPlayerState")

	if player.velocity.y < -3.0 and !player.is_on_floor():
		transition.emit("FallingPlayerState")
