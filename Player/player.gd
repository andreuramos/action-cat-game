extends KinematicBody2D

const MAX_SPEED = 100
const ACCELERATION = 500
const FRICTION = 500

enum {
	MOVE, ATTACK
}

var velocity = Vector2.ZERO
var direction = "R"
var state = MOVE

onready var _animation = $AnimatedSprite
onready var _pawPivot = $"Hitbox Pivot"

func _ready():
	_animation.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)

	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			direction = "R"
		elif input_vector.x < 0:
			direction = "L"
		_animation.play("walk" + direction)
		_rotate_paw_pivot(direction)
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		_animation.play("stand" + direction)
		
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK


func attack_state(delta):
	_pawPivot.get_child(0).get_child(0).disabled = false
	_animation.play("attack" + direction)
	
	
func _on_AnimatedSprite_animation_finished():
	_pawPivot.get_child(0).get_child(0).disabled = true
	state = MOVE
	
func _rotate_paw_pivot(direction):
	if direction == "R":
		_pawPivot.rotation_degrees = 0
	else:
		_pawPivot.rotation_degrees = 180
	
