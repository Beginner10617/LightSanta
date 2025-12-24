extends Node2D

@export var influence_radius := 4.0
@export var push_force := 700.0
@export var cooldown := 1.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var wave: AnimatedSprite2D = $AnimatedSprite2D2
@onready var area := $"."
@export var ringAudio: AudioStreamPlayer2D
@onready var lives: Label = $"../../EndScreen/HBoxContainer/Label"
@onready var endScreen: Node = $"../../EndScreen"

@onready var sky: Node = $"../../Sky"
func _ready() -> void:
	sprite.play("Idle")
	area.body_entered.connect(_on_body_entered)

func trigger() -> void:
	if sky.gameEnd:
		return
	ringAudio.play()
	# Death
	lives.text = str(int(lives.text)-1)
	if int(lives.text) <= 0: 
		sky.gameEnd = true
		endScreen.show_dead()
	# Play ring animation
	if sprite.animation != "Ring":
		sprite.play("Ring")
	if wave.animation != "Ring":
		wave.play("Ring")

	# Push player if inside radius
	for body in area.get_overlapping_bodies():
		if body is CharacterBody2D:
			var dir: Vector2 = (body.global_position - global_position).normalized()
			body.velocity += dir * push_force

	# Cooldown
	await get_tree().create_timer(cooldown).timeout

	sprite.play("Idle")
	wave.play("Idle")

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		trigger()
