extends ColorRect

@onready var window: ColorRect = $"."
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var resume_button: Button= $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Resume
@onready var control_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Controls
@onready var quit_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Quit


func _ready() -> void:
	window.visible=false
	resume_button.pressed.connect(unpause)
	quit_button.pressed.connect(get_tree().quit)

func _process(delta):

	if Input.is_action_just_pressed("exit") and window.visible==true:
		unpause()
		
	elif Input.is_action_just_pressed("exit") and window.visible==false:
		pause()
			
func unpause():
	animator.play("Unpause")
	get_tree().paused=false
	window.visible=false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func pause():
	animator.play("Pause")
	get_tree().paused=true
	window.visible=true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
