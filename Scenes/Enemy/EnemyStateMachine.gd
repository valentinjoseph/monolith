class_name EnemyStateMachine
extends Node

@export var default_state : EnemyState
var current_state : EnemyState
var states : Dictionary = {}

func _ready():
	await get_tree().create_timer(0.5).timeout #this is to make sure the mesh is created BEFORE the path
	#print(states)
	for child in get_children():
		if child is EnemyState:
			states[child.name] = child
			child.initialize()
			#print(child)
		
	if default_state != null:
		change_state(default_state.name)
		

func change_state(state_name):
	var new_state = states.get(state_name)
	
	if new_state == null:
		return
		
	if new_state == current_state:
		return
	
	if current_state != null:
		current_state.exit()
		
	current_state = new_state
	new_state.enter()
	Global.debug.add_property("Enemy State", new_state, 4)
func _process(delta):
	if current_state != null:
		current_state.update(delta)
		
func _kill():
	print("you dead")
			
func _physics_process(delta):
	if current_state != null:
		current_state.physics_update(delta)
		
#func _on_navigation_agent_3d_target_reached() -> void:
	#if current_state != null:
		#current_state.navigation_complete()


func _on_navigation_agent_3d_navigation_finished() -> void:
	if current_state != null:
		current_state.navigation_complete()
