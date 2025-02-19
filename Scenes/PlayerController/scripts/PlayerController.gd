class_name Player extends CharacterBody3D

#characters movements
var _speed: float
var _current_rotation:float
@export var SPEED_DEFAULT = 5.0
@export var JUMP_VELOCITY = 4.5


#crouching variables
var _is_crouching : bool = false
@onready var AnimPlayer: AnimationPlayer = $AnimationPlayer
@export var crouch_shapecast : Node3D


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
var gravity = 12.0 #ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()

func _unhandled_input(event: InputEvent) -> void:
	_mouse_input= event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input == true:
		_rotation_input = -event.relative.x * mouse_sensitivity
		_tilt_input = -event.relative.y * mouse_sensitivity
		
func _update_camera(delta):
	_current_rotation = _rotation_input
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
	#Global.debug.add_property("MovementSpeed", _speed, 2)
	
	_update_camera(delta)
	

func update_gravity(delta)->void:
	velocity.y -= gravity * delta
	
func update_input(speed:float,acceleration:float,deceleration:float)->void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration)
		velocity.z = lerp(velocity.z, direction.z * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)
	Global.debug.add_property("MovementSpeed", speed, 2)
	
func update_velocity() -> void:
	move_and_slide()
