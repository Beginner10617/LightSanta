extends Camera2D

@export var target: Node2D
@export var follow_speed := 8.0
@export var Offset := Vector2.ZERO
@export var deadzone := Vector2(0, 0)
@export var up_clamp := -4000.0
@onready var fixed_x := global_position.x

func _physics_process(delta: float) -> void:
	if target == null:
		return

	var desired_pos = target.global_position + Offset

	# Lock X axis
	desired_pos.x = fixed_x

	# Deadzone logic (Y only matters now)
	var diff = desired_pos - global_position
	if abs(diff.y) < deadzone.y:
		desired_pos.y = global_position.y
	if abs(desired_pos.y) > abs(up_clamp):
		desired_pos.y = up_clamp
	# Smooth interpolation
	global_position = global_position.lerp(desired_pos, follow_speed * delta)
