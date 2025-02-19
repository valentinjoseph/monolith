class_name FallingPlayerState

extends PlayerMovementState

@export var speed : float = 5.0
@export var acceleration: float = 0.1
@export var deceleration : float = 0.25
@export var double_jump_velocity : float = 4.5

var double_jump : bool = false

func enter(previous_state) -> void:
	animation.pause()
	
func exit() -> void:
	double_jump=false
	
func update(delta):
	player.update_gravity(delta)
	player.update_input(speed,acceleration,deceleration)
	player.update_velocity()
	
	if Input.is_action_just_pressed("jump") and double_jump==false:
		double_jump=true
		player.velocity.y=double_jump_velocity
	
	if player.is_on_floor():
		animation.play("jumpend")
		transition.emit("IdlePlayerState")
