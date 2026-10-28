extends Button

@export var camera: Camera2D
var is_muted: bool

func _ready():
	self.connect("pressed", _on_Button_pressed)
	is_muted = true

func _on_Button_pressed():
	is_muted = !is_muted

func _process(delta):
	if is_muted:
		AudioServer.set_bus_volume_db(0, 0)  # Установите уровень громкости на 0 дБ (включено)
	else:
		AudioServer.set_bus_volume_db(0, -80)  # Установите уровень громкости на -80 дБ (выключено)
