extends Node2D

@export var kvadrat: Sprite2D

@export var max_satellites_per_level: int
@export var satellite_scene_1: PackedScene
@export var satellite_scene_2: PackedScene
@export var satellite_scene_3: PackedScene
@export var satellite_scene_4: PackedScene
@export var satellite_scene_5: PackedScene
@export var satellite_scene_6: PackedScene
@export var satellite_scene_7: PackedScene
@export var satellite_scene_8: PackedScene

@export var rocket: CharacterBody2D
@export var cloud_scene_1: PackedScene  # Первая сцена облака
@export var cloud_scene_2: PackedScene  # Вторая сцена облака
@export var cloud_scene_3: PackedScene  # Третья сцена облака
@export var cloud_scene_4: PackedScene  # Первая сцена облака
@export var cloud_scene_5: PackedScene  # Вторая сцена облака
@export var cloud_scene_6: PackedScene  # Третья сцена облака
@export var cloud_scene_7: PackedScene  # Первая сцена облака
@export var cloud_scene_8: PackedScene  # Вторая сцена облака
@export var cloud_spawn_interval: float = 0.3  # Интервал спавна облаков
@export var max_clouds_per_level: int = 2  # Максимальное количество облаков на одном уровне
var cloud_timer: Timer
var camera: Camera2D

func _ready():
	camera = get_parent().get_node('Camera2D')  # Получаем камеру
	cloud_timer = Timer.new()
	cloud_timer.wait_time = cloud_spawn_interval
	cloud_timer.one_shot = false  # Таймер будет повторяться
	cloud_timer.connect("timeout", Callable(self, "_on_cloud_timer_timeout"))
	add_child(cloud_timer)
	cloud_timer.start()

func _on_cloud_timer_timeout():
	if camera.position.y < (-kvadrat.max_height - 5000):
		spawn_satellite()
	
	if camera.position.y > (-kvadrat.max_height + 20000):
		spawn_cloud()

func spawn_cloud():
	var cloud_scene: PackedScene

	# Случайный выбор одной из трех сцен облаков
	var random_choice = randi() % 7
	if random_choice == 0:
		cloud_scene = cloud_scene_1
	elif random_choice == 1:
		cloud_scene = cloud_scene_2
	elif random_choice == 2:
		cloud_scene = cloud_scene_3
	elif random_choice == 3:
		cloud_scene = cloud_scene_4
	elif random_choice == 4:
		cloud_scene = cloud_scene_5
	elif random_choice == 5:
		cloud_scene = cloud_scene_6
	elif random_choice == 6:
		cloud_scene = cloud_scene_7


	if cloud_scene:
		var cloud_instance = cloud_scene.instantiate()
		# Установите случайную позицию для облака
		var spawn_y = camera.position.y - 10000 + randf_range(-300, 300)  # Случайная высота

		# Проверяем количество облаков на заданной высоте
		if get_clouds_on_level(spawn_y) < max_clouds_per_level:
			cloud_instance.position.x = camera.position.x + randf_range(-2400, 2400)  # Начинаем справа от видимой области камеры
			cloud_instance.position.y = spawn_y
			add_child(cloud_instance)  # Добавляем облако в сцену

func spawn_satellite():
	var satellite_scene: PackedScene
	# Случайный выбор одной из трех сцен облаков
	var random_choice = randi() % 6
	if random_choice == 0:
		satellite_scene = satellite_scene_1
	elif random_choice == 1:
		satellite_scene = satellite_scene_2
	elif random_choice == 2:
		satellite_scene = satellite_scene_3
	elif random_choice == 3:
		satellite_scene = satellite_scene_4
	elif random_choice == 4:
		satellite_scene = satellite_scene_5
	elif random_choice == 5:
		satellite_scene = satellite_scene_6

	if satellite_scene:
		var cloud_instance = satellite_scene.instantiate()
		# Установите случайную позицию для облака
		var spawn_y = camera.position.y - 20000 + randf_range(-500, 500)  # Случайная высота

		# Проверяем количество облаков на заданной высоте
		if get_satellites_on_level(spawn_y) < max_satellites_per_level:
			cloud_instance.position.x = camera.position.x + randf_range(-2400, 2400)  # Начинаем справа от видимой области камеры
			cloud_instance.position.y = spawn_y
			add_child(cloud_instance)  # Добавляем облако в сцену

func get_clouds_on_level(y: float) -> int:
	var count = 0
	for child in get_children():
		if child is not Timer and abs(child.position.y - y) < 600:  # Проверяем, близки ли облака по высоте
			count += 1
	return count
func get_satellites_on_level(y: float) -> int:
	var count = 0
	for child in get_children():
		if child is not Timer and abs(child.position.y - y) < 800:  # Проверяем, близки ли облака по высоте
			count += 1
	return count
