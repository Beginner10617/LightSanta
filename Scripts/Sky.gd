extends Node

var time_passed := 0.0
var gameEnd := false
@export var max_height := -4000.0
@export var max_time := 120.0  # seconds till night
@onready var player: Node2D = $"../Player"
@onready var sky_rect: ColorRect = $ColorRect
@onready var sky_material: ShaderMaterial = sky_rect.material as ShaderMaterial
@onready var stars: Node = $Stars
@onready var clouds: Node = $Clouds
@onready var endScreen: Node = $"../EndScreen"

func _process(delta: float) -> void:
	if not player or gameEnd:
		return
	elif player.maxHeight >= abs(max_height):
		end_game()
	time_passed += delta

	var time_t := time_passed / max_time

	var progress :float= clamp(time_t, 0.0, 1.0)
	update_sky(progress)

	if progress >= 1.0:
		end_game()

func update_sky(t: float) -> void:
	# Sky gradient
	if sky_material:
		sky_material.set("shader_parameter/progress", t)

	# Stars fade in after dusk
	for star in stars.get_children():
		if star is CanvasItem:
			star.modulate.a = smoothstep(0.6, 1.0, t)

	# Clouds darken slightly
	var cloud_darkness :float= lerp(1.0, 0.6, t)
	for cloud in clouds.get_children():
		if cloud is CanvasItem:
			cloud.modulate = Color(
				cloud_darkness,
				cloud_darkness,
				cloud_darkness
			)
func end_game():
	gameEnd = true
	if player.maxHeight > abs(max_height):
		#print("WON")
		endScreen.show_win()
	else:
		#print("LOOSE")
		endScreen.show_lose()
	# Win/Loose screen
