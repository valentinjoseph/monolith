extends ColorRect

@onready var window: ColorRect = $"."
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var resume_button: Button= $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Resume
@onready var restart_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Restart
@onready var control_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Controls
@onready var quit_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Quit
@onready var context_component: ContextComponent = $"../ContextComponent"



func _ready() -> void:
	window.visible=false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	resume_button.pressed.connect(unpause)
	restart_button.pressed.connect(restart)
	quit_button.pressed.connect(get_tree().quit)

func _process(delta):

	if Input.is_action_just_pressed("exit") and window.visible==true:
		window.visible=false
		context_component.visible=true
		unpause()
		
	elif Input.is_action_just_pressed("exit") and window.visible==false:
		window.visible=true
		context_component.visible=false
		pause()
			
func unpause():
	animator.play("Unpause")
	get_tree().paused=false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func pause():
	animator.play("Pause")
	get_tree().paused=true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func restart():
	animator.play("Unpause")
	get_tree().paused=false
	get_tree().reload_current_scene()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
