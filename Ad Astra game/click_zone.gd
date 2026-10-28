extends Area2D

@export var camera: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = camera.position.x - 500
	position.y = camera.position.y - 500
	
