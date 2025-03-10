extends RayCast3D

@onready var raycast: RayCast3D = $"."
@export var throw_force := 200.0
var interact_cast_result
var current_cast_result

var held_object: RigidBody3D = null
var picked_up:bool=false

var object_position: Vector3=Vector3(2,0,0)


func _input(event):
	if event.is_action_pressed("interact"):
		interact()
	elif event.is_action_pressed("attack"):
		throw_object()

func _physics_process(delta: float) -> void:
	#Global.debug.add_property("MovementSpeed", _speed, 2)
	
	#_update_camera(delta)
	interact_cast()
	#if Input.is_action_pressed("attack") and held_object:
		##interact_cast_result.emit_signal("interacted")
		#throw_object()
		
func interact_cast()->void:
	current_cast_result = get_collider()
	
	
	if current_cast_result != interact_cast_result:
		if interact_cast_result and interact_cast_result.has_user_signal("unfocused"):
			interact_cast_result.emit_signal("unfocused")
			#print("unfocused")
		interact_cast_result = current_cast_result
		if interact_cast_result and interact_cast_result.has_user_signal("focused"):
			interact_cast_result.emit_signal("focused")
			#print("focused")
			
	
func interact() ->void:
	var body = raycast.get_collider()
	#print(body)
	if body is RigidBody3D and body.is_in_group("object"):
		if interact_cast_result and interact_cast_result.has_user_signal("interacted"):
			interact_cast_result.emit_signal("interacted")
			held_object=body


			
	if body is RigidBody3D and body.is_in_group("door"):
		if interact_cast_result and interact_cast_result.has_user_signal("interacted"):
			interact_cast_result.emit_signal("interacted")
		
	if body is not RigidBody3D:
		if interact_cast_result and interact_cast_result.has_user_signal("interacted"):
			interact_cast_result.emit_signal("interacted")
		
func throw_object():
	if held_object != null and held_object.is_in_group("object"):
	#if picked_up==true:
		interact_cast_result.emit_signal("thrown")
		held_object.apply_central_impulse(-raycast.global_transform.basis.y * throw_force)
		held_object.add_to_group("thrown_object")
		await get_tree().create_timer(1.0).timeout
		held_object.remove_from_group("thrown_object")
		held_object=null
		picked_up=false
		
		#interact_cast_result.emit_signal("unfocused")
	
