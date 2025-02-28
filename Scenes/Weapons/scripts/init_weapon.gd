@tool
class_name WeaponController
extends Node3D

signal weapon_fired
#signal enemy_hit(damage)

@onready var handgun_load: AudioStreamPlayer3D = $"../../../../../Sounds/HandgunLoad"
@onready var handgun_shoot: AudioStreamPlayer3D = $"../../../../../Sounds/HandgunShoot"


@export var weapon_type: Weapons:
	set(value):
		weapon_type = value
		if Engine.is_editor_hint():
			load_weapon()

@export var sway_noise: NoiseTexture2D
@export var sway_speed: float= 1.2
@export var reset : bool=false:
	set(value):
		reset=value
		if Engine.is_editor_hint():
			load_weapon()
			
			
@onready var weapon_mesh: MeshInstance3D = %WeaponMesh

var mouse_movement:Vector2
var random_sway_x
var random_sway_y
var random_sway_amount:float
var time: float = 0.0
var idle_sway_adjustment
var idle_sway_rotation_strength
var weapon_bob_amount : Vector2 = Vector2(0,0)

var raycast_test = preload("res://Assets/shooting/raycast_test.tscn")
var shoot_toggle:bool=false
var weapon1_toggle:bool=false
var weapon2_toggle:bool=true
var damage 

func _ready()->void:
	await owner.ready
	load_weapon()

func _input(event):
	if event.is_action_pressed("weapon1") and weapon1_toggle==true:
		weapon_type=load("res://Models/weapons/crowbar/CrowbarResource.tres")
		shoot_toggle=false
		weapon2_toggle=true
		weapon1_toggle=false
		damage= 15
		#print(damage)
		load_weapon()
	if event.is_action_pressed("weapon2") and weapon2_toggle==true:
		weapon_type=load("res://Models/weapons/handgun/HandgunResource.tres")
		handgun_load.play()
		shoot_toggle=true
		weapon2_toggle=false
		weapon1_toggle=true
		damage=25
		#print(damage)
		load_weapon()
		
	if event is InputEventMouseMotion:
		mouse_movement=event.relative	
		
func load_weapon()->void:
	weapon_mesh.mesh=weapon_type.mesh #set weapon mesh
	position=weapon_type.position #set weapon position
	rotation_degrees = weapon_type.rotation #set weapon rotation
	scale=weapon_type.scale #set weapon scale
	idle_sway_adjustment=weapon_type.idle_sway_adjustment
	idle_sway_rotation_strength=weapon_type.idle_sway_rotation_strength
	random_sway_amount=weapon_type.random_sway_amount

func sway_weapon(delta, isIdle:bool)-> void:

	#if Engine.is_editor_hint():
		#return
	#clamp mouse movement
	mouse_movement= mouse_movement.clamp(weapon_type.sway_min, weapon_type.sway_max)
	if isIdle:			
		#get random sway value from 2D noise
		var sway_random:float=get_sway_noise()
		var sway_random_adjusted: float= sway_random * idle_sway_adjustment #adjust sway strength
		
		#create time with delta and set two sine values for x and y sway movement
		time += delta * (sway_speed + sway_random)
		random_sway_x = sin(time * 1.5 + sway_random_adjusted)/ random_sway_amount
		random_sway_y = sin(time - sway_random_adjusted)/ random_sway_amount
	

		#lerp weapon position based on mouse movement
		position.x = lerp(position.x, weapon_type.position.x - (mouse_movement.x * weapon_type.sway_amount_position + random_sway_x) * delta, weapon_type.sway_speed_position)
		position.y = lerp(position.y, weapon_type.position.y + (mouse_movement.y * weapon_type.sway_amount_position + random_sway_y) * delta, weapon_type.sway_speed_position)
		#lerp weapon rotation based on mouse movement
		rotation_degrees.y = lerp(rotation_degrees.y, weapon_type.rotation.y + (mouse_movement.y * weapon_type.sway_amount_rotation + (random_sway_y * idle_sway_rotation_strength)) * delta, weapon_type.sway_speed_rotation)
		rotation_degrees.x = lerp(rotation_degrees.x, weapon_type.rotation.x - (mouse_movement.x * weapon_type.sway_amount_rotation + (random_sway_x * idle_sway_rotation_strength)) * delta, weapon_type.sway_speed_rotation)
	
	else:
		#lerp weapon position based on mouse movement
		position.x = lerp(position.x, weapon_type.position.x - (mouse_movement.x * weapon_type.sway_amount_position + weapon_bob_amount.x) * delta, weapon_type.sway_speed_position)
		position.y = lerp(position.y, weapon_type.position.y + (mouse_movement.y * weapon_type.sway_amount_position + weapon_bob_amount.y) * delta, weapon_type.sway_speed_position)
		#lerp weapon rotation based on mouse movement
		rotation_degrees.y = lerp(rotation_degrees.y, weapon_type.rotation.y + (mouse_movement.y * weapon_type.sway_amount_rotation) * delta, weapon_type.sway_speed_rotation)
		rotation_degrees.x = lerp(rotation_degrees.x, weapon_type.rotation.x - (mouse_movement.x * weapon_type.sway_amount_rotation) * delta, weapon_type.sway_speed_rotation)
	
func _weapon_bob(delta, bob_speed: float, hbob_amount: float, vbob_amount)-> void:
	time += delta
	
	weapon_bob_amount.x = sin(time * bob_speed) * hbob_amount
	weapon_bob_amount.y = abs(cos(time * bob_speed) * vbob_amount)

	
func get_sway_noise()->float:
	var player_position: Vector3=Vector3(0,0,0)
	#only access global variable when in game to avoid constant errors
	if not Engine.is_editor_hint():
		player_position=Global.player.global_position
		
	var noise_location: float = sway_noise.noise.get_noise_2d(player_position.x, player_position.y)
	return noise_location


func _attack() -> void:
	var camera = Global.player.camera_controller
	var space_state = camera.get_world_3d().direct_space_state
	var screen_center = get_viewport().size / 2
	var origin = camera.project_ray_origin(screen_center)
	var end = origin + camera.project_ray_normal(screen_center) * 1000
	var query = PhysicsRayQueryParameters3D.create(origin,end)
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	var result_collider= result.get("collider")
	#print(screen_center)
	if result and shoot_toggle==true:
		weapon_fired.emit()
		handgun_shoot.play()
		_bullet_hole(result.get("position"), result.get("normal"))
	if result and shoot_toggle==true and result_collider.is_in_group("enemy"):
		print("enemy shot")
		MessageBus.enemy_shot.emit(damage)
	if shoot_toggle==false:
		pass
		
func _bullet_hole(position: Vector3, normal : Vector3)-> void:
	var instance = raycast_test.instantiate()
	get_tree().root.add_child(instance)
	instance.global_position = position
	instance.look_at(instance.global_transform.origin + normal, Vector3.UP )
	if normal != Vector3.UP and normal != Vector3.DOWN:
		instance.rotate_object_local(Vector3(1,0,0), 90)
		
		
	
	await get_tree().create_timer(2).timeout
	var fade = get_tree().create_tween()
	fade.tween_property(instance, "modulate:a", 0, 1.5)
	await get_tree().create_timer(1.5).timeout
	instance.queue_free()
