class_name HealthComponent

extends Node

var parent
@export var health : float = 100
@export var hit_sound: AudioStreamPlayer3D 


func _ready()->void:
	parent=get_parent()
	#print(parent)
	MessageBus.enemy_hit.connect(_enemy_health)


		
func _enemy_health(result_collider, damage):
	if parent==result_collider:
		health -= damage
		var hsp = hit_sound.global_transform.origin
		var pp = parent.global_position
		hsp=pp
		print("hsp: ", hsp)
		print("pp : ", pp)	
		hit_sound.play()
		#print(health)
		if health <=0:
			parent.queue_free()
	else:
		pass
	
