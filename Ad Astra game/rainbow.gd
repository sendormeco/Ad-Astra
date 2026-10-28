extends Sprite2D
var time_elapsed: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += 0.01
	if time_elapsed > 60:
		if modulate.a < 0.5:
			modulate.a += 0.0001
