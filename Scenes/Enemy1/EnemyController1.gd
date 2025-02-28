class_name EnemyController1

extends CharacterBody3D

var parent
@export var health : float = 100
@export var enemy: CharacterBody3D


func _ready()->void:
	MessageBus.enemy1_hit.connect(_enemy_health)


		
func _enemy_health(damage):
	health -= damage
	if health <=0:
		queue_free()
		
