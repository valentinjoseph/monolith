class_name PlayerMovementState

extends State

var player: Player
var animation : AnimationPlayer

func _ready():
	await owner.ready	
	player = owner as Player
	animation = player.AnimPlayer
func _process(delta):
	pass
