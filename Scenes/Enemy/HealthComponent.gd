class_name HealthComponent

extends Node

var parent
@export var health : float = 100

func _ready()->void:
	parent = get_parent()
	#print(parent)
	MessageBus.enemy_shot.connect(_enemy_health)
	
func _enemy_health(damage):
	print(health)
	health -= damage
	if health <=0:
		parent.queue_free()
