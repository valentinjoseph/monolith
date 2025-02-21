class_name FallingPlayerState

extends PlayerMovementState

@export var speed : float = 5.0
@export var acceleration: float = 0.1
@export var deceleration : float = 0.25
@export var double_jump_velocity : float = 4.5

@export var weapon_bob_spd: float= 1.0
@export var weapon_bob_h: float = 1.0
@export var weapon_bob_v : float = 4.0

var double_jump : bool = false

func enter(previous_state) -> void:
	animation.pause()
	
func exit() -> void:
	double_jump=false
	
func update(delta):
	player.update_gravity(delta)
	player.update_input(speed,acceleration,deceleration)
	player.update_velocity()
	
	weapon.sway_weapon(delta, false)
	weapon._weapon_bob(delta, weapon_bob_spd, weapon_bob_h, weapon_bob_v)
	
	if Input.is_action_just_pressed("jump") and double_jump==false:
		double_jump=true
		player.velocity.y=double_jump_velocity
	
	if Input.is_action_just_pressed("attack"):
		weapon._attack()
	
	if player.is_on_floor():
		animation.play("jumpend")
		transition.emit("IdlePlayerState")
