extends TouchScreenButton

const UPGRADES_FILE = "user://upgrades.cfg"

func _ready():
	add_to_group("control_buttons")
	pressed.connect(_on_right_pressed)
	released.connect(_on_released)
	load_upgrades()
# Добавляем Area2D в группу
	$Area2D.add_to_group("control_buttons")


func _on_right_pressed():
	Input.action_press("right_move")  # Нажатие действия "right_move"

func _on_released():
	Input.action_release("right_move")  # Отпускание кнопки

func load_upgrades():
	var config = ConfigFile.new()
	if config.load(UPGRADES_FILE) == OK:
		var control_upgrades = config.get_value("Upgrades", "control", 0)
		if control_upgrades > 1 and OS.has_feature("android"):
			visible = true
