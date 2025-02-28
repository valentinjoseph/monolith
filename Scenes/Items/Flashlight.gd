extends Node3D

@onready var flashlight: Node3D = $"."
@onready var click: AudioStreamPlayer3D = $click
@onready var flashlight_toggle:bool=true



func _ready():
	flashlight.visible=false
	
	
func _process(delta)->void:
	if  flashlight.visible==false and flashlight_toggle ==true and Input.is_action_just_pressed("flashlight"):
		flashlight.visible = true
		click.play()
	elif flashlight.visible==true and  flashlight_toggle ==true and Input.is_action_just_pressed("flashlight"):
		flashlight.visible = false
		click.play()
