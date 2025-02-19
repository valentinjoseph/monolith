class_name WalkingPlayerState

extends PlayerMovementState

@export var speed : float = 5.0
@export var acceleration: float = 0.1
@export var deceleration : float = 0.25
@export var top_anim_speed : float = 2.2

@export var weapon_bob_spd: float= 6.0
@export var weapon_bob_h: float = 2.0
@export var weapon_bob_v : float = 1.0
func enter(previous_state) -> void:
	if animation.is_playing() and animation.current_animation == "jumpend":
		await animation.animation_finished
		animation.play("walking", -1.0, 1.0)
	else:
		animation.play("walking", -1.0, 1.0)

func exit() -> void:
	animation.speed_scale = 1.0
	
func update(delta):
	player.update_gravity(delta)
	player.update_input(speed,acceleration,deceleration)
	player.update_velocity()

	weapon.sway_weapon(delta, false)
	weapon._weapon_bob(delta, weapon_bob_spd, weapon_bob_h, weapon_bob_v)
		
	set_animation_speed(player.velocity.length())
	
	if Input.is_action_pressed("sprint") and player.is_on_floor():
		transition.emit("SprintingPlayerState")
		
	if Input.is_action_just_pressed("crouch") and player.is_on_floor():
		transition.emit("CrouchingPlayerState")
		
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		transition.emit("JumpingPlayerState")
		
	if player.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")
		
	if player.velocity.y < -3.0 and !player.is_on_floor():
		transition.emit("FallingPlayerState")
		
func set_animation_speed(spd):
	var alpha = remap (spd, 0.0, speed, 0.0, 1.0)
	animation.speed_scale = lerp (0.0, top_anim_speed, alpha)
