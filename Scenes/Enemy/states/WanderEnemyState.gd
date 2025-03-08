extends EnemyState

var home_position : Vector3
@export var max_wander_range : float = 6
@export var min_wait_time : float = 0.2
@export var max_wait_time : float = 2.0
@export var chase_range : float = 4.0
#@onready var anim: AnimationPlayer = $"../../AnimationPlayer"

func enter():
	super.enter()
	#anim.play("walk")
	home_position=controller.position
	_new_wander_position()

func navigation_complete():
	#anim.play("idle")
	var wait_time=randf_range(min_wait_time, max_wait_time)
	await get_tree().create_timer(wait_time).timeout
	
	if not active:
		return
	
	_new_wander_position()
	#anim.play("walk")
	
func _new_wander_position():
	var pos=home_position+random_offset() * randf_range(0, max_wander_range)
	controller.move_to_position(pos)

func update(delta):
	if controller.player_distance < chase_range:
		state_machine.change_state("ChaseEnemyState")
