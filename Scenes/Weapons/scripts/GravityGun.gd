extends Node3D
#
#@export var max_distance := 10.0
#@export var throw_force := 20.0
#@export var pick_up_force := 10.0
#
#var held_object: RigidBody3D = null
#
#@onready var hold_point: Marker3D = $HoldPoint
#@onready var raycast: RayCast3D = $RayCast3D
#
#func _process(delta):
	#if held_object:
		#move_held_object(delta)
#
#func move_held_object(delta):
	#var direction = (hold_point.global_transform.origin - held_object.global_transform.origin)
	#held_object.linear_velocity = direction * pick_up_force
#
#func _input(event):
	#print(raycast.get_collider())
	#if event.is_action_pressed("interact"):  # Pick up / Drop
		#if held_object:
			#drop_object()
		#else:
			#pick_up_object()
	#
	#if event.is_action_pressed("attack") and held_object:  # Throw object
		#throw_object()
#
#func pick_up_object():
	#if raycast.is_colliding():
		#var body = raycast.get_collider()
		#if body is RigidBody3D:
			#held_object = body
			#held_object.freeze = false
			#held_object.linear_velocity = Vector3.ZERO
			#held_object.angular_velocity = Vector3.ZERO
			#held_object.set_as_top_level(true)
#
#func drop_object():
	#if held_object:
		#held_object.set_as_top_level(false)
		#held_object = null
#
#func throw_object():
	#if held_object:
		#held_object.apply_impulse(Vector3.ZERO, -raycast.global_transform.basis.z * throw_force)
		#drop_object()
