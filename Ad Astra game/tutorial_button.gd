extends Button

func _ready():
	pressed.connect(_on_tutorial_button_pressed)

func _on_tutorial_button_pressed():
	# Плавное исчезание перед выходом
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.1)
	tween.tween_callback(_tutorial)

func _tutorial():
	# Для веб-версии (нельзя закрыть вкладку скриптом)
	if OS.has_feature("web"):
		get_tree().change_scene_to_file("res://ui/exit_screen.tscn")
	else:
		get_tree().change_scene_to_file("res://tutorial.tscn")
