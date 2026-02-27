extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@export var walk_speed = 200
@export var crouch_speed = 50
@export var gravity = 200
@export var jump_speed = -300


var is_crouching = false
var jump_count = 0
var max_jumps = 2

func _ready() -> void:
	jump_count = 0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jump_count = 0

	is_crouching = Input.is_action_pressed("ui_down")

	var speed = walk_speed
	if is_crouching:
		velocity.y += gravity * 20 * delta
		speed = crouch_speed

	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed

	if Input.is_action_just_pressed("ui_up") and jump_count < max_jumps and not is_crouching:
		velocity.y = jump_speed
		jump_count += 1

	move_and_slide()

	update_animation(direction)
	
func update_animation(direction):
	if is_crouching and is_on_floor() and velocity.x == 0:
		sprite.play("player_crouch")
	elif not is_on_floor():
		sprite.play("player_jump")
	elif velocity.x != 0:
		sprite.play("player_run")
	elif velocity.x == 0 and not is_crouching:
		sprite.play("player_idle")
		
	if direction < 0:
		sprite.flip_h = true
	elif direction > 0:
		sprite.flip_h = false
