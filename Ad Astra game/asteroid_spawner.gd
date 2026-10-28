extends Node2D

@export var kvadrat: Sprite2D
@export var camera: Camera2D
@export var grey_asteroid_scenes: Array[PackedScene]
@export var asteroid_scenes: Array[PackedScene]  # Массив для хранения сцен астероидов
@export var spawn_interval: float = 4.0  # Интервал спавна
var last_spawned_y: float = -5000.0  # Начальная Y-координата
var min_distance: float = 1000.0  # Минимальное расстояние между астероидами
@export var spawn_start_height: float  # Минимальная высота для спавна астероидов

func _ready():
	spawn_start_height = kvadrat.max_height
	# Запускаем таймер для спавна
	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.one_shot = false
	timer.connect("timeout", _on_spawn_timer_timeout)
	add_child(timer)
	timer.start()

func _on_spawn_timer_timeout():
	# Проверка, чтобы камера была на нужной высоте
	if camera.position.y > -spawn_start_height:
		return
	if camera.position.y > -kvadrat.max_height * 2:
		spawn_asteroid()
		return
	else:
		spawn_grey_asteroid()

func spawn_asteroid():

	var random_scene = asteroid_scenes[randi() % asteroid_scenes.size()]
	var asteroid = random_scene.instantiate()
	
	# Генерируем случайные координаты
	var random_x = randf_range(camera.position.x - 1400, camera.position.x + 1400)
	var random_y = randf_range(camera.position.y - 5000, camera.position.y - 3000)
	
	var spawn_position = Vector2(random_x, random_y)
	
	# Проверка на занятость позиции
	if not is_position_occupied(spawn_position):
		asteroid.global_position = spawn_position
		add_child(asteroid)
		print("Spawned asteroid at: ", asteroid.position)

func spawn_grey_asteroid():
	spawn_interval = 0.5
	min_distance = 1200
	# Выбираем случайную сцену астероида
	var random_scene = grey_asteroid_scenes[randi() % asteroid_scenes.size()]
	var asteroid = random_scene.instantiate()
	
	# Генерируем случайные координаты
	var random_x = randf_range(camera.position.x - 1400, camera.position.x + 1400)
	var random_y = randf_range(camera.position.y - 5000, camera.position.y - 3000)
	
	var spawn_position = Vector2(random_x, random_y)
	
	# Проверка на занятость позиции
	if not is_position_occupied(spawn_position):
		asteroid.global_position = spawn_position
		add_child(asteroid)
		print("Spawned asteroid at: ", asteroid.position)


func is_position_occupied(position: Vector2) -> bool:
	for child in get_children():
		if child is Node2D and child.position.distance_to(position) < min_distance:
			return true
	return false
