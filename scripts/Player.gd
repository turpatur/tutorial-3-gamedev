extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@export var walk_speed = 200
@export var gravity = 200
@export var jump_speed = -300

var jump_count = 0
var max_jumps = 2

func _ready() -> void:
	jump_count = 0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jump_count = 0

	if Input.is_action_just_pressed("ui_up") and jump_count < max_jumps:
		velocity.y = jump_speed
		jump_count += 1

	if Input.is_action_pressed("ui_left"):
		velocity.x = -walk_speed
		sprite.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		velocity.x = walk_speed
		sprite.flip_h = false
	else:
		velocity.x = 0

	if not is_on_floor():
		sprite.play("player_jump")
	elif velocity.x != 0:
		sprite.play("player_run")
	else:
		sprite.play("player_idle")

	move_and_slide()
