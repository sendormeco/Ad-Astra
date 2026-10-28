extends Node2D  # Корневой узел вашей главной сцены

@onready var fade_rect = $FadeRect
@onready var secret_audio1 = $AudioStreamPlayer4
@onready var starting_audio = $AudioStreamPlayer
@onready var cash_audio = $AudioStreamPlayer2
@onready var space_audio = $AudioStreamPlayer3
@export var upgrade_controller = Node2D
@onready var stars_collected: int = 0
@onready var custom_cursor_texture = preload("res://cursor_h.png")
@onready var progress_bar: TextureProgressBar
@onready var rocket_indicator: TextureRect
@onready var score: int = 0
@onready var high_score: int = 0
@export var moon: Sprite2D
@export var kvadrat: Sprite2D
@export var initial_fuel_upgrade_price: int = 25
@export var initial_magnet_upgrade_price: int = 500
@export var initial_engine_upgrade_price: int = 250
@export var initial_control_upgrade_price: int = 500
@export var initial_armor_upgrade_price: int = 2500
@export var fuel_upgrade_label: RichTextLabel
@export var engine_upgrade_label: RichTextLabel
@export var control_upgrade_label: RichTextLabel
@export var armor_upgrade_label: RichTextLabel
@export var magnet_upgrade_label: RichTextLabel
@export var kvadRat: Sprite2D
@export var camera: Camera2D
@export var pause_button: Button
@export var rocket: CharacterBody2D
@export var score_label: RichTextLabel
@export var high_score_label: RichTextLabel
@export var stars_label: RichTextLabel
@export var restart_stars_label: Label
@export var restart_score_label: Label
@export var restart_high_score_label: Label
@export var combo_label: Label
@export var achivement_label: Label
@export var restart_menu: Control
@export var fuel_label: RichTextLabel
@export var fuel_upgrade_button: Button
@export var starting_music_fade_time: float = 100000
@export var fade_duration: float = 1
@onready var backg = $Camera2D/ColorRect
var paused = false
var last_rocket_position_y: float = 0.0
const HIGH_SCORE_FILE = "user://high_score.cfg"
const STARS_FILE = "user://stars.cfg"
const UPGRADES_FILE = "user://upgrades.cfg"
var stars_collected_today: int = 0
var fuel_upgrades: int = 0
var magnet_upgrades: int = 0
var engine_upgrades: int = 0
var control_upgrades: int = 0
var armor_upgrades: int = 0
var fuel_upgrade_price: int
var control_upgrade_price: int
var engine_upgrade_price: int
var magnet_upgrade_price: int
var armor_upgrade_price: int
var music_changed = false
var reached_space = false
var reached_outer_space = false
var reached_moon = false
var _android_initialized := false

func _ready():
	_create_fade_rect()
	var fade_in = create_tween()
	fade_in.tween_property(fade_rect, "modulate:a", 0.0, fade_duration)
	fade_in.tween_callback(_remove_fade_rect)  # Удаляем после завершения
	if OS.get_name() == "Android":
		# Первая инициализация
		_fix_android_viewport()
		
		# Дублирующий фикс через 0.5 сек
		await get_tree().create_timer(0.05).timeout
		_fix_android_viewport()
	# Создаем ColorRect динамически

	
	# Запускаем эффект появления

	stars_collected_today = 0
	Input.set_custom_mouse_cursor(custom_cursor_texture)
	kvadRat = $KvadRat
	camera = $Camera2D
	progress_bar = $Camera2D/TextureProgressBar
	rocket_indicator = $Camera2D/RocketIndicator
	progress_bar.max_value = kvadRat.max_height
	backg.position = progress_bar.position
	backg.position.x -= 7
	load_high_score()  # Загружаем рекорд при запуске игры
	load_stars_collected()
	reset_upgrades()
	load_upgrades()
	set_upgrade_prices()
	rocket_load_upgrade_config()
	update_upgrade_prices()

func _physics_process(delta):
	update_achivement_label()
	update_fuel_label()
	update_stars_label()
	update_high_score()
	update_combo_label()
	score_label.text = str(score)
	high_score_label.text = "РК " + str(high_score)
	restart_high_score_label.text = "РЕКОРД " + str(high_score)
	restart_score_label.text = "СЧЁТ " + str(score)
	restart_stars_label.text = "ЗВЁЗД СОБРАНО " + str(stars_collected_today)
	#reset_upgrades()
	if rocket.global_position.y < -kvadrat.max_height:
		change_music()
		reached_space = true
	
	if rocket.global_position.y < -kvadrat.max_height * 1.5:
		reached_outer_space = true
		
	if rocket.global_position.y < moon.position.y:
		reached_moon = true
	
	
	var distance = kvadRat.max_height + camera.position.y
	progress_bar.value = clamp(distance, 0, progress_bar.max_value)

	var rocket_position = ((progress_bar.max_value - distance) / progress_bar.max_value) * progress_bar.size.y
	rocket_indicator.position = Vector2(progress_bar.position.x, progress_bar.position.y + 2 * progress_bar.size.y - rocket_position - 200)
	if rocket_indicator.position.y < progress_bar.position.y - 50:
		rocket_indicator.visible = false
	if rocket.position.y < last_rocket_position_y:
		var distance_travelled = -rocket.position.y + last_rocket_position_y
		score += distance_travelled * 0.03  # Увеличьте множитель по необходимости
		last_rocket_position_y = rocket.position.y

func update_stars_label():
	stars_label.text = str(stars_collected)


func _exit_tree():
	Input.set_custom_mouse_cursor(null)

func picked_up_star():
	score += 10
	stars_collected += 1
	stars_collected_today += 1
	

func update_high_score():
	if score > high_score:
		high_score = score

func on_reload_button():
	rocket.is_active = true
	Engine.time_scale = 1
	restart_scene()

func restart_scene():
	save_upgrades()
	save_high_score()
	save_stars_collected()
	reset_upgrades()
	get_tree().reload_current_scene()

func update_combo_label():
	combo_label.text = "X" + str(rocket.current_acceleration_multiplier - 1)

	var multiplier = rocket.current_acceleration_multiplier - 1
	var color: Color
	var current_multiplier = 0
	if multiplier == 0:
		current_multiplier = 0
	
	if multiplier > 1 and multiplier - current_multiplier >= 1:
		combo_label.visible = true
		combo_label.modulate.a = 1
		current_multiplier = multiplier
		combo_label.text = "X" + str(multiplier)
	else:
		combo_label.visible = false  # Скрываем label, если множитель 1 или меньше
	# Интерполяция цветов
	if multiplier < 2:
		color = Color(0, 1, 0)  # Зелёный
	elif multiplier > 12:
		color = Color(0.5, 0, 1)  # Фиолетовый
	else:
		var t = (multiplier - 2) / 10.0  # Нормализация для плавного перехода
		if t <= 0.25:
			color = Color(0, 1, 0).lerp(Color(1, 1, 0), t * 4)  # Зелёный к жёлтому
		elif t <= 0.5:
			color = Color(1, 1, 0).lerp(Color(1, 0, 0), (t - 0.25) * 4)  # Жёлтый к красному
		elif t <= 0.75:
			color = Color(1, 0, 0).lerp(Color(1, 0, 1), (t - 0.5) * 4)  # Красный к розовому
		else:
			color = Color(1, 0, 1).lerp(Color(0.5, 0, 1), (t - 0.75) * 4)  # Розовый к фиолетовому

	combo_label.modulate = color  # Устанавливаем цвет текста
	

func save_high_score():
	var config = ConfigFile.new()
	config.set_value("HighScore", "score", high_score)  # Сохраняем значение high_score
	config.save(HIGH_SCORE_FILE)

func load_high_score():
	var config = ConfigFile.new()
	if config.load(HIGH_SCORE_FILE) == OK:
		high_score = config.get_value("HighScore", "score", 0)  # Получаем значение
	else:
		print("Не удалось загрузить рекорд. Устанавливаем в 0.")
		high_score = 0

func save_stars_collected():
	var config = ConfigFile.new()
	config.set_value("Stars", "collected", stars_collected)
	config.save(STARS_FILE)

func load_stars_collected():
	var config = ConfigFile.new()
	if config.load(STARS_FILE) == OK:
		stars_collected = config.get_value("Stars", "collected", 0)
	else:
		print("Не удалось загрузить количество собранных звёзд. Устанавливаем в 0.")
		stars_collected = 0

func rocked_died():
	var current_score = score  # Предполагаем, что счёт хранится в Global
	if RecordsManager.is_new_record(current_score):
		RecordsManager.add_record(current_score)
	restart_menu.visible = true
	Engine.time_scale = 0
	
func update_fuel_label():
	fuel_label.text = "Топливо: " + str(rocket.fuel) + "/" + str(rocket.max_fuel)

func update_upgrade_prices():
	if fuel_upgrades < 50:
		fuel_upgrade_label.text = str(fuel_upgrade_price)
	else:
		fuel_upgrade_label.text = "MAX"
	if magnet_upgrades < 6:
		magnet_upgrade_label.text = str(magnet_upgrade_price)
	else:
		magnet_upgrade_label.text = "MAX"
	if engine_upgrades < 11:
		engine_upgrade_label.text = str(engine_upgrade_price)
	else:
		engine_upgrade_label.text = "MAX"
	if control_upgrades < 6:
		control_upgrade_label.text = str(control_upgrade_price)
	else:
		control_upgrade_label.text = "MAX"
	if armor_upgrades < 5:
		armor_upgrade_label.text = str(armor_upgrade_price)
	else:
		armor_upgrade_label.text = "MAX"
	print(fuel_upgrade_price, " text is ", fuel_upgrade_label.text)


func _on_fuel_upgrade_button_pressed():
	if stars_collected >= fuel_upgrade_price and fuel_upgrades < 50:
		stars_collected -= fuel_upgrade_price
		save_stars_collected()
		fuel_upgrades += 1
		save_upgrades()
		load_upgrades()
		set_upgrade_prices()
		update_upgrade_prices()
		rocket_load_upgrade_config()
		cash_audio.play()

func _on_magnet_upgrade_button_pressed():
	if stars_collected >= magnet_upgrade_price and magnet_upgrades < 6:
		stars_collected -= magnet_upgrade_price
		save_stars_collected()
		magnet_upgrades += 1
		save_upgrades()
		load_upgrades()
		set_upgrade_prices()
		update_upgrade_prices()
		rocket_load_upgrade_config()
		cash_audio.play()

func _on_engine_upgrade_button_pressed():
	if stars_collected >= engine_upgrade_price and engine_upgrades < 11:
		stars_collected -= engine_upgrade_price
		save_stars_collected()
		engine_upgrades += 1
		save_upgrades()
		load_upgrades()
		set_upgrade_prices()
		update_upgrade_prices()
		rocket_load_upgrade_config()
		cash_audio.play()

func _on_control_upgrade_button_pressed():
	if stars_collected >= control_upgrade_price and control_upgrades < 6:
		stars_collected -= control_upgrade_price
		save_stars_collected()
		control_upgrades += 1
		save_upgrades()
		load_upgrades()
		set_upgrade_prices()
		update_upgrade_prices()
		rocket_load_upgrade_config()
		cash_audio.play()

func _on_armor_upgrade_button_pressed():
	if stars_collected >= armor_upgrade_price and armor_upgrades < 5:
		stars_collected -= armor_upgrade_price
		save_stars_collected()
		armor_upgrades += 1
		save_upgrades()
		load_upgrades()
		set_upgrade_prices()
		update_upgrade_prices()
		rocket_load_upgrade_config()
		cash_audio.play()

func save_upgrades():
	var config = ConfigFile.new()
	config.set_value("Upgrades", "fuel", fuel_upgrades)
	config.set_value("Upgrades", "magnet", magnet_upgrades)
	config.set_value("Upgrades", "engine", engine_upgrades)
	config.set_value("Upgrades", "control", control_upgrades)
	config.set_value("Upgrades", "armor", armor_upgrades)
	config.save(UPGRADES_FILE)

func load_upgrades():
	var config = ConfigFile.new()
	if config.load(UPGRADES_FILE) == OK:
		fuel_upgrades = config.get_value("Upgrades", "fuel", 0)
		magnet_upgrades = config.get_value("Upgrades", "magnet", 0)
		engine_upgrades = config.get_value("Upgrades", "engine", 0)
		control_upgrades = config.get_value("Upgrades", "control", 0)
		armor_upgrades = config.get_value("Upgrades", "armor", 0)
	else:
		print("Не удалось загрузить апгрейды. Устанавливаем в 0.")
		
func reset_upgrades():
	fuel_upgrades = 1
	magnet_upgrades = 1
	engine_upgrades = 1
	control_upgrades = 1
	armor_upgrades = 1
	
func rocket_load_upgrade_config():
	rocket.max_fuel = 10 + (fuel_upgrades - 1) * 1
	rocket.fuel = rocket.max_fuel
	rocket.acceleration += engine_upgrades * 0.07 * rocket.acceleration
	rocket.extra_acceleration += engine_upgrades * 0.07 * rocket.extra_acceleration
	rocket.fuel_regen_amount += (fuel_upgrades / 10)
	rocket.control_multiplier = 0.2 * control_upgrades
	rocket.control_friction -= 0.00003 * control_upgrades
	rocket.armor = armor_upgrades
	if magnet_upgrades > 1:
		rocket.is_magnet_active = true
		rocket.magnet_area.scale = Vector2(75 + 50 * (magnet_upgrades -1), 75 + 50 * (magnet_upgrades - 1))
	

func set_upgrade_prices():
	fuel_upgrade_price = fuel_upgrades * 2 * initial_fuel_upgrade_price
	magnet_upgrade_price = magnet_upgrades * 2 * initial_magnet_upgrade_price
	control_upgrade_price = control_upgrades * 2 * initial_control_upgrade_price
	engine_upgrade_price = engine_upgrades * 2 * initial_engine_upgrade_price
	armor_upgrade_price = armor_upgrades * 2 * initial_armor_upgrade_price

func change_music():
	if randi() % 10000 == 0:
		space_audio = $AudioStreamPlayer4
	starting_audio.volume_db = lerp(starting_audio.volume_db, -80.0, 0.005)
	
	if starting_audio.volume_db <= -59 and music_changed == false:  # Проверяем, завершили ли приглушение
		starting_audio.stop()
		space_audio.play()
		space_audio.volume_db = lerp(-10, 0, 0.005)
		music_changed = true
		# Вы можете также добавить эффект нарастания громкости новой музыки здесь, если хотите

func update_achivement_label():
	if reached_moon:
		achivement_label.text = "You reached moon!"
		achivement_label.visible = true
	elif reached_outer_space:
		achivement_label.text = "Far space reached!"
		achivement_label.visible = true
	elif reached_space:
		achivement_label.text = "You reached space"
		achivement_label.visible = true
	else:
		achivement_label.visible = false
		
func _fix_android_viewport():
	if _android_initialized: return
	
	# 1. Получаем реальные размеры с учетом системных панелей
	var display := DisplayServer.screen_get_size()
	var safe_area := DisplayServer.get_display_safe_area()
	
	# 2. Принудительно обновляем Viewport
	var viewport := get_viewport()
	viewport.size = display
	
	# 3. Специальный фикс для Godot 4+
	viewport.disable_render_target()
	viewport.enable_render_target()
	
	# 4. Корректируем камеру
	if viewport.get_camera_2d():
		viewport.get_camera_2d().reset_smoothing()
	
	# 5. Настраиваем фон
	$Background.scale = Vector2(
		safe_area.size.x / $Background.texture.get_width(),
		(safe_area.size.y * 1.4) / $Background.texture.get_height()
	)
	$Background.position = Vector2(0, -safe_area.size.y * 0.35)
	
	_android_initialized = true
	print("Android viewport fixed")
func _on_restart_game():
	# При перезапуске сбрасываем флаг
	_android_initialized = false
	if OS.get_name() == "Android":
		await get_tree().create_timer(0.1).timeout
		_fix_android_viewport()

func _create_fade_rect():
	# Создаем ColorRect
	fade_rect = ColorRect.new()
	fade_rect.color = Color.BLACK
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Для CanvasLayer или Control
	if get_class() == "CanvasLayer" or get_class() == "Control":
		fade_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	# Для Node2D
	else:
		var viewport_size = get_viewport().get_visible_rect().size
		fade_rect.position = -viewport_size
		fade_rect.size = viewport_size * 2.0  # С запасом
	
	camera.add_child(fade_rect)
	
	# Перемещаем на верхний слой
	if get_class() == "CanvasLayer":
		fade_rect.z_index = 999  # Максимальный приоритет
	else:
		move_child(fade_rect, get_child_count() - 1)
	
	# Важно: перемещаем на самый верх
	move_child(fade_rect, get_child_count() - 1)

func _remove_fade_rect():
	if is_instance_valid(fade_rect):
		fade_rect.queue_free()

func change_scene_with_fade(target_scene: String):
	# Создаем новый ColorRect для перехода
	_create_fade_rect()
	fade_rect.modulate.a = 0.0  # Начинаем прозрачным
	
	var fade_out = create_tween()
	fade_out.tween_property(fade_rect, "modulate:a", 1.0, fade_duration)
	fade_out.tween_callback(func():
		get_tree().change_scene_to_file(target_scene)
	)

func on_exit_button():
	save_upgrades()
	save_high_score()
	save_stars_collected()
	reset_upgrades()
	get_tree().change_scene_to_packed(preload("res://main_menu.tscn"))
