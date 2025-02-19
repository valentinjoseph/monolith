class_name Player2 extends CharacterBody3D

#characters movements
var _speed: float
@export var SPEED_DEFAULT = 5.0
@export var SPEED_CROUCH = 2.0
@export var SPEED_SPRINT = 7.0
@export var acceleration : float = 0.1
@export var deceleration : float = 0.25
@export var JUMP_VELOCITY = 4.5


#crouching variables
var _is_crouching : bool = false
@onready var AnimPlayer: AnimationPlayer = $AnimationPlayer
@export_range(5, 10, 0.1) var crouch_speed : float = 7.0
@export var crouch_shapecast : Node3D
@export var crouch_toggle : bool = true


#mouse variables
var _mouse_input : bool = false
var _mouse_rotation : Vector3
var _rotation_input : float
var _tilt_input : float
var _player_rotation : Vector3
var _camera_rotation : Vector3
@export var mouse_sensitivity : float = 0.2
@export var tilt_lower_limit := deg_to_rad(-90.0)
@export var tilt_upper_limit := deg_to_rad(90.0)
@export var camera_controller : Camera3D


#get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")




func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
	if event.is_action_pressed("crouch") and is_on_floor():
		toggle_crouch()
	if event.is_action_pressed("crouch") and _is_crouching == false and is_on_floor() and crouch_toggle == false:
		#hold to crouch
		crouching(true)
	if event.is_action_released("crouch") and crouch_toggle==false:
		#release to uncrouch
		if crouch_shapecast.is_colliding()==false:
			crouching(false)
		elif crouch_shapecast.is_colliding()==true:
			uncrouch_check()	

func _unhandled_input(event: InputEvent) -> void:
	_mouse_input= event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input == true:
		_rotation_input = -event.relative.x * mouse_sensitivity
		_tilt_input = -event.relative.y * mouse_sensitivity
		
func _update_camera(delta):
	#rotate camera using euler rotation
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, tilt_lower_limit, tilt_upper_limit)
	_mouse_rotation.y += _rotation_input * delta
	
	_player_rotation = Vector3(0.0, _mouse_rotation.y, 0.0)
	_camera_rotation = Vector3( _mouse_rotation.x, 0.0, 0.0)
	
	camera_controller.transform.basis = Basis.from_euler(_camera_rotation)
	camera_controller.rotation.z = 0.0
	
	global_transform.basis = Basis.from_euler(_player_rotation)
	
	_rotation_input = 0.0
	_tilt_input = 0.0
	
func _ready():
	
	Global.player=self
	#get mouse input
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	#set default speed
	_speed = SPEED_DEFAULT
	
	#add crouch check shapecast collision exception for CharacterBody3D node
	crouch_shapecast.add_exception($".")
	
func _physics_process(delta: float) -> void:
	Global.debug.add_property("MovementSpeed", _speed, 2)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	_update_camera(delta)
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and _is_crouching==false:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * _speed, acceleration)
		velocity.z = lerp(velocity.z, direction.z * _speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)

	move_and_slide()


#######################
##CROUCHING FUNCTIONS
#######################

func toggle_crouch():
	if _is_crouching == true and crouch_shapecast.is_colliding() == false:
		print ("UNCROUCH")
		crouching(false)
	elif _is_crouching ==false:
		print ("CROUCH")
		crouching(true)
		
func uncrouch_check():
	if crouch_shapecast.is_colliding()==false:
		crouching(false)
	if crouch_shapecast.is_colliding()==true:
		await get_tree().create_timer(0.1).timeout
		uncrouch_check()
		
func crouching(state : bool):
	match state:
		true:
			AnimPlayer.play("crouch", 0, crouch_speed)
			set_movement_speed("crouching")
		false:
			AnimPlayer.play("crouch", 0, -crouch_speed, true)
			set_movement_speed("default")
			

func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "crouch":
		_is_crouching = ! _is_crouching
		
func set_movement_speed(state : String):
	match state:
		"default":
			_speed = SPEED_DEFAULT
		"crouching":
			_speed = SPEED_CROUCH
