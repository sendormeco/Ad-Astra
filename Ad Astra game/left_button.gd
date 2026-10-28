extends TouchScreenButton

const UPGRADES_FILE = "user://upgrades.cfg"

func _ready():
	add_to_group("control_buttons")
	pressed.connect(_on_left_pressed)
	released.connect(_on_released)
	load_upgrades()
	$Area2D.add_to_group("control_buttons")
	

func _on_left_pressed():
	Input.action_press("left_move")  # Нажатие действия "left_move"

func _on_released():
	Input.action_release("left_move")  # Отпускание кнопки

func load_upgrades():
	var config = ConfigFile.new()
	if config.load(UPGRADES_FILE) == OK:
		var control_upgrades = config.get_value("Upgrades", "control", 0)
		if control_upgrades > 1 and OS.has_feature("android"):
			visible = true
