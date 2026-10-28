extends Button

func _ready():
	pressed.connect(_on_exit_button_pressed)
	if OS.has_feature("web"):
		visible = false

func _on_exit_button_pressed():
	# Плавное исчезание перед выходом
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.1)
	tween.tween_callback(_quit_game)

func _quit_game():
	# Для веб-версии (нельзя закрыть вкладку скриптом)
	if OS.has_feature("web"):
		get_tree().change_scene_to_file("res://ui/exit_screen.tscn")
	else:
		get_tree().quit()  # Стандартный выход
