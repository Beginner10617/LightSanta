extends "res://Scripts/Bell.gd"

enum MoveType { LINEAR, CIRCULAR }
@export var move_type := MoveType.LINEAR

# Linear movement
@export var move_axis := Vector2.RIGHT
@export var move_distance := 64.0
@export var move_speed := 2.0

# Circular movement
@export var radius := 48.0
@export var angular_speed := 2.0
@export var phase := 0.0;

var _start_pos: Vector2
var _time := 0.0

func _ready() -> void:
	super()
	_start_pos = global_position

func _physics_process(delta: float) -> void:
	_time += delta

	match move_type:
		MoveType.LINEAR:
			var offset := sin(_time * move_speed) * move_distance
			global_position = _start_pos + move_axis.normalized() * offset

		MoveType.CIRCULAR:
			var angle := _time * angular_speed + phase * PI/180
			global_position = _start_pos + Vector2(
				cos(angle),
				sin(angle)
			) * radius
