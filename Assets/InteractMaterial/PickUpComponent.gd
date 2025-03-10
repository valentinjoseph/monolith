@tool

class_name PickUpComponent
extends Node

@export var pickup_distance: Vector3 = Vector3(0, 0, -2)
@export var mesh: MeshInstance3D

var parent
var object: Node3D
var picked_up: bool=false


const pickup_lerp:float= 0.2

func _ready()->void:
	parent = get_parent()
	if parent is InteractionComponent:
		parent.player_interacted.connect(update_state)

func _physics_process(delta:float)->void:
	if picked_up:
		var camera_transform=Global.player.camera_controller.global_transform
		object.global_transform=object.global_transform.interpolate_with(camera_transform.translated_local(pickup_distance), pickup_lerp)	

func _get_configuration_warnings() -> PackedStringArray:
	if parent is not InteractionComponent:
		return ["This node must have an InteractionComponent parent"]
	else:
		return []

func _notification(what: int)->void:
	if what==NOTIFICATION_ENTER_TREE:
		parent=get_parent()
		update_configuration_warnings()

func set_transparency(is_picked_up: bool, transparent : bool):
	# Find the MeshInstance3D inside the RigidBody3D
	if mesh:
		for i in range(mesh.get_surface_override_material_count()):  # Loop through all surfaces
			var mat = mesh.get_surface_override_material(i)
			if mat:
				mat = mat.duplicate()  # Duplicate to avoid modifying the original material
			else:
				mat = StandardMaterial3D.new()  # Create a new material if none exists
			mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA  # Enable transparency
			mat.albedo_color.a = 0.2 if transparent else 1.0  # Adjust alpha
			mesh.set_surface_override_material(i, mat)  # Apply updated material

	
func update_state(interactable: Node3D) -> void:
	if picked_up:
		picked_up=false
		set_transparency(false,false)
		object = null
		interactable.freeze=false
	else:
		picked_up=true
		set_transparency(true,true)
		object = interactable
		interactable.freeze=true
