class_name JumpingPlayerState

extends PlayerMovementState

@export var speed : float = 6.0
@export var acceleration: float = 0.1
@export var deceleration : float = 0.25
@export var jump_velocity : float = 4.5
@export var double_jump_velocity : float = 4.5
@export_range(0.5, 1.0, 0.1) var input_multiplier: float = 0.85

@export var weapon_bob_spd: float= 1.0
@export var weapon_bob_h: float = 1.0
@export var weapon_bob_v : float = 4.0

var double_jump : bool = false

func enter(previous_state)->void:
	player.velocity.y += jump_velocity
	animation.play("jumpstart")

func exit()->void:
	double_jump=false
	
func update(delta):
	player.update_gravity(delta)
	player.update_input(speed * input_multiplier,acceleration,deceleration)
	player.update_velocity()
	
	weapon.sway_weapon(delta, false)
	weapon._weapon_bob(delta, weapon_bob_spd, weapon_bob_h, weapon_bob_v)
	
	if Input.is_action_just_pressed("jump") and double_jump==false:
		double_jump=true
		player.velocity.y=double_jump_velocity
	
	if Input.is_action_just_pressed("attack"):
		weapon._attack()
		
	if Input.is_action_just_released("jump"):
		if player.velocity.y > 0:
			player.velocity.y = player.velocity.y / 2.0
			
	if player.velocity.y < -3.0 and !player.is_on_floor():
		transition.emit("FallingPlayerState")
		
	if player.is_on_floor():
		animation.play("jumpend")
		transition.emit("IdlePlayerState")
