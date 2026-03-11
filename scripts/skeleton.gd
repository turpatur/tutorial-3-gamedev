extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var audio = $bone_rattle
@onready var kill_sound = $kill_sound

@export var speed = 100
@export var distance = 100
@export var gravity = 900
@export var sound_delay = 0.4

var start_x
var direction = 1
var is_dead = false


func _ready():
	add_to_group("enemy")
	start_x = global_position.x
	sprite.play("skeleton_walk")
	sound_loop()


func _physics_process(delta):
	if is_dead:
		return
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = speed * direction
	move_and_slide()

	if direction == 1 and global_position.x >= start_x + distance:
		direction = -1
		sprite.flip_h = true

	elif direction == -1 and global_position.x <= start_x - distance:
		direction = 1
		sprite.flip_h = false


func stomped():
	if is_dead:
		return

	is_dead = true
	velocity = Vector2.ZERO
	kill_sound.play()
	sprite.play("skeleton_death")
	
	await kill_sound.finished
	queue_free()

func sound_loop():
	while true:
		if is_dead:
			return
		audio.play()
		await audio.finished
		await get_tree().create_timer(sound_delay).timeout
