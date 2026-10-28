extends CanvasLayer

var music_volume: float = 1.0    # Текущая громкость музыки (0..1)
var sound_volume: float = 1.0    # Текущая громкость звуков (0..1)
var trail_enabled: bool = true   # Включен ли след ракеты

func _ready():
	load_settings()
	update_ui()
	# Подключаем сигналы элементов управления
	$MusicSlider.connect("value_changed", Callable(self, "_on_music_slider_changed"))
	$SoundSlider.connect("value_changed", Callable(self, "_on_sound_slider_changed"))
	$TrailToggle.connect("toggled", Callable(self, "_on_trail_toggled"))
	$BackButton.connect("pressed", Callable(self, "_on_back_button_pressed"))

# Сохраняем настройки в файл
func save_settings():
	var settings = {
		"music_volume": music_volume,
		"sound_volume": sound_volume,
		"trail_enabled": trail_enabled
	}
	var file = FileAccess.open("user://settings.dat", FileAccess.WRITE)
	if file:
		file.store_var(settings)

# Загружаем настройки из файла
func load_settings():
	if FileAccess.file_exists("user://settings.dat"):
		var file = FileAccess.open("user://settings.dat", FileAccess.READ)
		if file:
			var settings = file.get_var()
			music_volume = settings.get("music_volume", 1.0)
			sound_volume = settings.get("sound_volume", 1.0)
			trail_enabled = settings.get("trail_enabled", true)

# Обновляем UI (слайдеры и переключатели)
func update_ui():
	$MusicSlider.value = music_volume
	$SoundSlider.value = sound_volume
	$TrailToggle.button_pressed = trail_enabled

# Применяем громкость музыки через аудиобус
func apply_music_volume():
	var music_bus_idx = AudioServer.get_bus_index("Music")
	if music_bus_idx != -1:
		AudioServer.set_bus_volume_db(music_bus_idx, linear_to_db(music_volume))

# Применяем громкость звуков через аудиобус
func apply_sound_volume():
	var sound_bus_idx = AudioServer.get_bus_index("Sounds")
	if sound_bus_idx != -1:
		AudioServer.set_bus_volume_db(sound_bus_idx, linear_to_db(sound_volume))

# Сигналы элементов управления
func _on_music_slider_changed(value: float):
	music_volume = value
	save_settings()
	apply_music_volume()

func _on_sound_slider_changed(value: float):
	sound_volume = value
	save_settings()
	apply_sound_volume()

func _on_trail_toggled(button_pressed: bool):
	trail_enabled = button_pressed
	save_settings()
	# Отправляем сигнал об изменении настроек следа
	Events.emit_signal("trail_setting_changed", trail_enabled)

func _on_back_button_pressed():
	save_settings()
	get_tree().change_scene_to_file("res://main_menu.tscn")
