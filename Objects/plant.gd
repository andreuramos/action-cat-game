extends Node2D

onready var animation = $AnimatedSprite

func _ready():
	animation.play("default")
	

func _on_Hurtbox_area_entered(area):
	if area.name == 'Hitbox':
		animation.play("die")
