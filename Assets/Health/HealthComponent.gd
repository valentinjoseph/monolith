class_name HealthComponent

extends Node

var parent
@export var health : float = 100


func _ready()->void:
	parent=get_parent()
	#print(parent)
	MessageBus.enemy_hit.connect(_enemy_health)


		
func _enemy_health(result_collider, damage):
	if parent==result_collider:
		health -= damage
		#print(health)
		if health <=0:
			parent.queue_free()
	else:
		pass
	
