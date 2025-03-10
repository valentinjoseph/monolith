extends EnemyState

#@onready var anim: AnimationPlayer = $"../../AnimationPlayer"

@export var stop_range : float = 1.0 #where the enemy stops from player
@export var lose_interest_range : float = 10.0

var path_update_rate : float = 0.1
var last_path_update_time : float

func enter():
	super.enter()
	#anim.play("walk")
	controller.is_running=true
	controller.look_at_player=true
	
func exit():
	super.exit()
	#anim.stop()
	controller.is_running=false
	controller.look_at_player=false
	
func update(delta):
	var current_time=Time.get_unix_time_from_system()
	
	if current_time - last_path_update_time > path_update_rate:
		last_path_update_time=current_time
		controller.move_to_position(controller.player.position, false)
		
	if controller.player_distance < stop_range:
		controller.is_stopped=true
		#state_machine._kill()
	
	if controller.player_distance > lose_interest_range:
		state_machine.change_state("WanderEnemyState")
