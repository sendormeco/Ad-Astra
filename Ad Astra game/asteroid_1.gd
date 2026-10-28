extends Node2D

@export var speed: float = 300.0
@onready var area = $Area2D
@onready var audio_stream_player = $AudioStreamPlayer
@onready var direction
# Called when the node enters the scene tree for the first time.
func _ready():
	direction = randf_range(-1, 1)
	area.connect("body_entered", Callable(self, '_on_body_entered'))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= speed * delta * direction

func _on_body_entered(body):
	if body.is_in_group("rocket"):
		audio_stream_player.play()
		if body.armor > 1:
			hide()
			body.armor -= 1
		else:
			body.velocity = Vector2(0, 0)
			body.die()
