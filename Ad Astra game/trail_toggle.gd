extends Button

@onready var normal_color = modulate  # Сохраняем исходный цвет
var pressed_color = Color(0.75, 0.75, 0.75)  # Голубоватый цвет для нажатого состояния

func _ready():
	# Загружаем сохраненное состояние
	if FileAccess.file_exists("user://trail.setting"):
		button_pressed = FileAccess.open("user://trail.setting", FileAccess.READ).get_var()
	update_appearance()
	
	toggled.connect(_on_toggled)

func _on_toggled(is_pressed: bool):
	update_appearance()
	# Сохраняем состояние
	FileAccess.open("user://trail.setting", FileAccess.WRITE).store_var(is_pressed)

func update_appearance():
	var tween = create_tween()
	if button_pressed:
		tween.tween_property(self, "modulate", pressed_color, 0.2)
	else:
		tween.tween_property(self, "modulate", normal_color, 0.2)
