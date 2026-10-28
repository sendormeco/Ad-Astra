extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$BackButton.connect("pressed", Callable(self, "_on_back_button_pressed"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
