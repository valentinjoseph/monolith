class_name DoorComponent
extends Node

@export var direction: Vector3
@export var door_size: Vector3
@export var speed : float = 0.5
@export var close_time : float = 2.0
@export var transition: Tween.TransitionType
@export var easing: Tween.EaseType
@export var rotation : Vector3
@export var rotation_speed : float


var parent
var orig_pos: Vector3
var orig_rot: Vector3

func _ready()-> void:
	parent = get_parent()
	orig_pos= parent.position #get original position of door
	orig_rot=parent.rotation #get original rotation of door
	parent.ready.connect(connect_parent) # wait for parent to load to connect interaction signal
	
func connect_parent()-> void:
	parent.connect("interacted", Callable(self, "open_door")) #"interacted" created with Interaction Component
	
func open_door()-> void:
	var tween= get_tree().create_tween()
	tween.tween_property(parent, "position", orig_pos + (direction * door_size), speed).set_trans(transition).set_ease(easing)
	tween.tween_property(parent, "rotation", orig_rot + rotation, rotation_speed).set_trans(transition).set_ease(easing)
	tween.tween_interval(close_time)
	tween.tween_callback(close_door)#close the door after set time
	
func close_door()-> void:
	var tween= get_tree().create_tween()
	tween.tween_property(parent, "position", orig_pos, speed).set_trans(transition).set_ease(easing)
	tween.tween_property(parent, "rotation", orig_rot, rotation_speed).set_trans(transition).set_ease(easing)
