extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var stomp_area = $StompArea

@export var walk_speed = 200
@export var crouch_speed = 100
@export var gravity = 900
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

var downward_attack = false

var last_left_tap_time = -1.0
var last_right_tap_time = -1.0


func _ready():
	add_to_group("player")
	jump_count = 0


func _physics_process(delta):

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
		downward_attack = false

	is_crouching = Input.is_action_pressed("ui_down") and not is_dashing

	if is_dashing:

		dash_time_left -= delta
		velocity.x = dash_direction * dash_speed

		if dash_time_left <= 0:
			is_dashing = false

	else:

		var speed = walk_speed

		if is_crouching:
			speed = crouch_speed

			if not is_on_floor():
				velocity.y += gravity * 20 * delta
				downward_attack = true

		var direction = Input.get_axis("ui_left", "ui_right")
		velocity.x = direction * speed

		if Input.is_action_just_pressed("ui_up") and jump_count < max_jumps and not is_crouching:
			velocity.y = jump_speed
			jump_count += 1

	move_and_slide()

	update_animation()


func start_dash(direction):

	is_dashing = true
	dash_time_left = dash_duration
	dash_direction = direction


func update_animation():

	if is_crouching and velocity.x == 0:

		if sprite.animation != "player_crouch":
			sprite.play("player_crouch")

	elif not is_on_floor():

		if sprite.animation != "player_jump":
			sprite.play("player_jump")

	elif velocity.x != 0:

		if sprite.animation != "player_run":
			sprite.play("player_run")

	else:

		if sprite.animation != "player_idle":
			sprite.play("player_idle")

	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false


func _on_stomp_area_body_entered(body):
	if not body.is_in_group("enemy"):
		return
		
	var falling_stomp = velocity.y > 0 and global_position.y < body.global_position.y
	
	var dash_stomp = downward_attack
	
	if not falling_stomp and not dash_stomp:
		return
	
	downward_attack = false
	velocity.y = jump_speed * 0.7
	body.stomped()
