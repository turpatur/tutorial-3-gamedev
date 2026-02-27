extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

@export var walk_speed = 200
@export var crouch_speed = 100
@export var gravity = 200
@export var jump_speed = -300

@export var dash_speed = 500
@export var dash_duration = 0.2
@export var double_tap_time = 0.5

var jump_count = 0
var max_jumps = 2

var is_crouching = false
var is_dashing = false
var dash_time_left = 0.0
var dash_direction = 0

var last_left_tap_time = -1.0
var last_right_tap_time = -1.0

func _ready() -> void:
	jump_count = 0

func _physics_process(delta: float) -> void:
	var current_time = Time.get_ticks_msec() / 1000.0

	if Input.is_action_just_pressed("ui_left"):
		if current_time - last_left_tap_time <= double_tap_time and not is_crouching:
			start_dash(-1)
		last_left_tap_time = current_time

	if Input.is_action_just_pressed("ui_right"):
		if current_time - last_right_tap_time <= double_tap_time and not is_crouching:
			start_dash(1)
		last_right_tap_time = current_time

	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jump_count = 0

	is_crouching = Input.is_action_pressed("ui_down") and not is_dashing

	if is_dashing:
		dash_time_left -= delta
		velocity.x = dash_direction * dash_speed
		if dash_time_left <= 0:
			is_dashing = false
	else:
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
	update_animation()

func start_dash(direction: int):
	is_dashing = true
	dash_time_left = dash_duration
	dash_direction = direction

func update_animation():
	if is_crouching and velocity.x == 0:
		sprite.play("player_crouch")
	elif not is_on_floor():
		sprite.play("player_jump")
	elif velocity.x != 0:
		sprite.play("player_run")
	elif is_on_floor() and velocity.x == 0:
		sprite.play("player_idle")

	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false
