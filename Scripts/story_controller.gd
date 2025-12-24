extends Node2D

@onready var assistant := $Assistant
@onready var dialogue_label := $DialogueBox/Panel/Label
@onready var fade := $Fade/ColorRect

# Sprites
@export var sprite_clouds: Texture2D
@export var sprite_ground: Texture2D
@export var sprite_bellow: Texture2D
@export var bellow: Sprite2D
@export var wind: Sprite2D

# Tilemaps
@export var SkyTiles: TileMapLayer
@export var LandTiles: TileMapLayer

var step := 0
var can_advance := true
var skipped := false   

func _ready() -> void:
	fade.modulate.a = 0.0
	start_scene()

func start_scene() -> void:
	SkyTiles.visible = true
	wind.visible = false
	LandTiles.visible = false

	await wait()
	if skipped: return

	show_dialogue("Santa hasn’t been well lately…")
	await wait()
	if skipped: return

	assistant.texture = sprite_clouds
	show_dialogue("Guess it’s my turn to deliver gifts now.")
	await wait()
	if skipped: return

	show_dialogue("Though… I’m way thinner than him, huh?")
	await wait()
	if skipped: return

	# Wind moment
	wind.visible = true
	show_dialogue("— WAIT WHAT IS THAT WIND?!")
	apply_wind()
	await wait(1.5)
	if skipped: return

	# Fade out
	await fade_out()
	if skipped: return

	wind.visible = false

	# Ground scene
	SkyTiles.visible = false
	LandTiles.visible = true
	assistant.texture = sprite_ground
	assistant.position.x = 0
	assistant.rotation = 0
	show_dialogue("…Ow.")
	fade.modulate.a = 0.0
	await wait()
	if skipped: return

	show_dialogue("How am I supposed to reach the skies before night?")
	await wait()
	if skipped: return

	bellow.visible = false
	assistant.texture = sprite_bellow
	show_dialogue("What's this? Maybe this could work.")
	await wait()
	if skipped: return

	go_to_game()

func show_dialogue(text: String) -> void:
	dialogue_label.text = text
	can_advance = true

func wait(time := 0.0) -> void:
	if time == 0.0:
		while can_advance and not skipped:
			await get_tree().process_frame
	else:
		can_advance = false
		var t := get_tree().create_timer(time)
		while not skipped and t.time_left > 0:
			await get_tree().process_frame

func apply_wind() -> void:
	assistant.position.x += 220
	assistant.rotation = 0.2

func fade_out() -> void:
	while fade.modulate.a < 1.0 and not skipped:
		fade.modulate.a += 0.03
		await get_tree().process_frame

func skip_to_game() -> void:
	if skipped:
		return
	skipped = true
	go_to_game()

func go_to_game() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and can_advance:
		can_advance = false

	# SKIP INPUT 
	if event.is_action_pressed("ui_cancel"):  # Esc / B / Back
		skip_to_game()
