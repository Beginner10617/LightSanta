extends CanvasLayer

@export var fade_speed := 1.5

@onready var overlay := $ColorRect
@onready var title := $VBoxContainer/Title
@onready var subtitle := $VBoxContainer/Subtitle
@onready var restartButton := $VBoxContainer/Restart
@onready var backButton := $VBoxContainer/Back
@onready var liveBox := $HBoxContainer
var fade_in := false

func _ready() -> void:
	overlay.modulate.a = 0.0
	title.text = ""
	subtitle.text = ""
	restartButton.visible = false
	backButton.visible = false

func show_win():
	start_fade()
	title.text = "Christmas Saved"
	subtitle.text = "The gifts reached the skies in time"

func show_lose():
	start_fade()
	title.text = "Too Late"
	subtitle.text = "The night arrived too soon"

func show_dead():
	start_fade()
	title.text = "A Rough Ascent"
	subtitle.text = "The climb proved too unforgiving this time"

func start_fade():
	restartButton.visible = true
	backButton.visible = true
	overlay.modulate.a = 0.0
	fade_in = true
	liveBox.visible = false

func _process(delta: float) -> void:
	if not fade_in:
		return

	overlay.modulate.a += fade_speed * delta
	
	if overlay.modulate.a >= 1.0:
		overlay.modulate.a = 1.0
		fade_in = false

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
