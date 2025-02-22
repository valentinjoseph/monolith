extends AudioStreamPlayer3D

@export var footstep_sounds : Array[AudioStream]
@export var play_rate : float = 0.4
@export var last_play_time : float
@export var min_velocity: float = 0.5
#@onready var standing_collision: CollisionShape3D = $"../StandingCollision"



@onready var player: Player = $"../.."

func _process(delta):
	if not player.is_on_floor():
		stop()
		
	if player.velocity.length() < min_velocity:
		stop()
		
	if Input.is_action_pressed("crouch")==true:
		stop()
	#in case of sprinting
	if Input.is_action_just_pressed("sprint")==true:
		play_rate=0.3
		pitch_scale=randf_range(0.8,1.2)
	if Input.is_action_just_released("sprint")==true:
		play_rate=0.4
		pitch_scale=randf_range(0.8,1.2)

		

			
	if Time.get_unix_time_from_system() - last_play_time< play_rate:
		return
		
	last_play_time = Time.get_unix_time_from_system()
	stream = footstep_sounds[randi() % len(footstep_sounds)]
	play()
