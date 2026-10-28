extends ColorRect
@export var camera: Camera2D
# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = camera.position.x - 3000
	position.y = camera.position.y - 10000

	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
