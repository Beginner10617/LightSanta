extends CanvasLayer

@export var panel : Panel;
var paused := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panel.visible = false

func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause():
	paused = not paused;
	get_tree().paused = paused
	panel.visible = paused


func _on_button_pressed() -> void:
	paused = false
	get_tree().paused = paused
	panel.visible = paused

func _on_button_2_pressed() -> void:
	paused = false
	get_tree().paused = paused
	panel.visible = paused
	get_tree().reload_current_scene()

func _on_button_3_pressed() -> void:
	paused = false
	get_tree().paused = paused
	panel.visible = paused
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
