class_name EnemyState
extends Node

#import the classes as variables
var active : bool #this will be true or false if it is the CURRENT state
var state_machine : EnemyStateMachine
var controller : EnemyController


@export_node_path("EnemyController") var controller_path : NodePath

func initialize():
	state_machine = get_parent()
	controller = get_node(controller_path)
	
func enter():
	active = true
	#if state is the current state
	
func exit():
	active = false
	#if state is no longer active
	
func update(delta):
	pass
	
func physics_update(delta):
	pass
	
func navigation_complete():
	pass
	
func random_offset() -> Vector3:
	var offset = Vector3(randf_range(-1,1), 0, randf_range(-1,1))
	return offset.normalized()
