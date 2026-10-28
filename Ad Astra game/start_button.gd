extends Button

func _ready():
	pressed.connect(_on_exit_button_pressed)

func _on_exit_button_pressed():
	# Плавное исчезание перед выходом
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.1)
	tween.tween_callback(_start_game)

func _start_game():
		get_tree().change_scene_to_file("res://space_race.tscn")
