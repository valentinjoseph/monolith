extends EnemyState

var home_position : Vector3
#@onready var anim: AnimationPlayer = $"../../AnimationPlayer"
@export var chase_range : float = 1.0


func enter():
	super.enter()
	#anim.play("idle")
	home_position=controller.position
	controller.is_running=false
	controller.look_at_player=true
	
func exit():
	super.exit()
	#anim.stop()

func update(delta):
	if controller.player_distance < chase_range:
		state_machine.change_state("wander")
