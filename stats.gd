extends Node

export(int) var max_health = 1
onready var health = max_health

signal no_health

func decrease_health(value):
	health -= value
	if (health <= 0):
		emit_signal("no_health")
