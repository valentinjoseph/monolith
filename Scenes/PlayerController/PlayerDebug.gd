extends PanelContainer


@onready var property_container: VBoxContainer = %VBoxContainer

#var property
var frames_per_second: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set global references to self singleton
	Global.debug=self
	visible=false


	
func _process(delta):
	if visible:
		#use delta time to get approx frames per second and round to two decimal places
		#disable Vsync if FPS is stuck at 60
		frames_per_second = "%.2f" % (1.0/delta) #gets frames per second every frame
		#frames per second = Engine.get_frames_per_second() #gets frames per second every second
		Global.debug.add_property("FPS", frames_per_second, 1)



func _input(event):
	#toggle debug panel
	if event.is_action_pressed("debug"):
		visible= !visible
		
func add_property (title: String, value, order):
	var target
	target = property_container.find_child(title, true,false) #try to find label node with same name
	if !target: #if there is no current label node for property
		target=Label.new()
		property_container.add_child(target) 
		target.name = title
		target.text = target.name+ ": "+str(value)
	elif visible: #if exists and panel is visible
		target.text=title+ ": "+str(value) #update text value
		property_container.move_child(target,order) #reorder property based on given order value
		
