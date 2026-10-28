extends Area2D
@onready var audio_stream_player = $AudioStreamPlayer2D
func _ready():
	self.connect("body_entered", Callable(self, '_on_body_entered'))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	pass
