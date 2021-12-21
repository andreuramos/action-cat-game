extends KinematicBody2D

const KNOCKBACK_SPEED = 120
enum {
	IDLE,
	WANDER,
	CHASE,
	DEAD
}
var state = IDLE
var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

export var direction = "R"
export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 150

onready var stats = $stats
onready var animations = $AnimatedSprite
onready var hurtBox = $CollisionShape2D/Hurtbox
onready var collider = $CollisionShape2D
onready var playerDetector = $PlayerDetectionZone

func _ready():
	animations.play("fly" + direction)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	match state:
		IDLE: 
			animations.play("fly" + direction)
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerDetector.player
			if player != null:
				var chase_direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(chase_direction * MAX_SPEED, ACCELERATION * delta)
				if chase_direction.x < 0:
					direction = "L"
				else:
					direction = "R"
			else:
				state = IDLE
				
		DEAD:
			velocity = Vector2.ZERO
				
	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetector.can_see_player():
		state = CHASE

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
	
	
