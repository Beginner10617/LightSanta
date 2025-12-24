extends CharacterBody2D

const BOOST_FORCE := 750.0
const HORIZONTAL_ACCEL := 1200.0

@export var linear_damping := 2.5
@export var max_speed := 1000.0
@export var wrap_margin := 32.0

@export var rotationSpeed := 10.0
@export var theta := 1.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var blow: AnimatedSprite2D = $AnimatedSprite2D2
var targetAngle := 0.0
var maxHeight := 0.0;
@onready var sky : Node = $"../Sky"

func _ready() -> void:
	sprite.play("Idle")

func _physics_process(delta: float) -> void:
	if sky.gameEnd : return
	# Gravity
	velocity += get_gravity() * delta
	maxHeight = max(maxHeight, abs(global_position.y))
	# Vertical boost
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y -= BOOST_FORCE
		if sprite.animation != "Fly":
			sprite.play("Fly")
		if blow.animation != 'Blow':
			blow.play("Blow")
	# Horizontal steering
	var input_x := Input.get_axis("ui_left", "ui_right")
	velocity.x += input_x * HORIZONTAL_ACCEL * delta
	targetAngle = velocity.x / max_speed * theta

	# Damping
	velocity *= exp(-linear_damping * delta)

	# Clamp
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed

	# --- Animation state driven by vertical motion ---
	if sprite.animation not in ["Fly", "Fall-transition"]:
		if velocity.y > 300.0:
			if sprite.animation != "Fall":
				sprite.play("Fall")
		else:
			if sprite.animation != "Idle":
				sprite.play("Idle")

	# Rotation (slower during Fly)
	var rot_speed := rotationSpeed
	if sprite.animation == "Fly":
		rot_speed *= 0.6
	rotation = lerp_angle(rotation, targetAngle, rot_speed * delta)

	# Horizontal wrap
	var cam := get_viewport().get_camera_2d()
	if cam:
		var viewport_size := cam.get_viewport_rect().size
		var half_width := (viewport_size.x * 0.5) / cam.zoom.x
		var left := cam.global_position.x - half_width - wrap_margin
		var right := cam.global_position.x + half_width + wrap_margin

		if global_position.x < left:
			global_position.x = right
		elif global_position.x > right:
			global_position.x = left

	move_and_slide()

func _on_animated_sprite_2d_animation_finished() -> void:
	match sprite.animation:
		"Fly":
			blow.play("Idle")
			# Decide what comes after boost
			if velocity.y > 0:
				sprite.play("Fall-transition")
			else:
				sprite.play("Idle")

		"Fall-transition":
			sprite.play("Fall")
