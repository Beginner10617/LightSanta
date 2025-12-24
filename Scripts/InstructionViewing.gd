extends Node2D

@export var keys : TextureRect;
@export var waitTime := 10.0
var time = 0.0
var done = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if time > waitTime and not done:
		keys.visible = false
		done = true
	
	
