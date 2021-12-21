extends KinematicBody2D

const KNOCKBACK_SPEED = 120
enum {
	ALIVE,
	DEAD
}
var state = ALIVE
var knockback = Vector2.ZERO
export var direction = "R"
onready var stats = $stats
onready var animations = $AnimatedSprite
onready var hurtBox = $CollisionShape2D/Hurtbox
onready var collider = $CollisionShape2D

func _ready():
	animations.play("fly" + direction)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 150 * delta)
	knockback = move_and_slide(knockback)
	if state == ALIVE: 
		animations.play("fly" + direction)

func _on_Hurtbox_area_entered(area):
	var player = area.find_parent('player')

	if (player == null || area.name != 'Hitbox' || state == DEAD):
		return

	direction = 'L'
	if player.direction == 'L':
		direction = 'R'
	stats.decrease_health(area.damage)

	if player.direction == 'R':
		knockback = Vector2.RIGHT * KNOCKBACK_SPEED
	else:
		knockback = Vector2.LEFT * KNOCKBACK_SPEED

func _on_stats_no_health():
	animations.play("die" + direction)
	animations.connect("animation_finished", self, "_handle_death")
	state = DEAD

func _handle_death():
	if collider != null:
		collider.queue_free()
	
	
