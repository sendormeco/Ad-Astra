extends Node2D

@export var kvadrat: Sprite2D
@export var snakes_scene: PackedScene
@export var we_are_rich_scene: PackedScene
@export var two_lines_scene: PackedScene
@export var we_are_poor: PackedScene  # Бюджетная сцена
@export var budget_snakes: PackedScene  # Бюджетная сцена
@export var single_line: PackedScene
@export var true_rocket: CharacterBody2D
@export var up_arrow: PackedScene
@export var UB1: PackedScene
@export var UB2: PackedScene
@export var UB3: PackedScene
@export var spawn_distance: float = 450.0  # Расстояние для спавна объектов
@export var crosses: PackedScene
var last_spawned_y: float = -5000.0  # Начальная Y-координата
@export var camera: Camera2D  # Ссылка на ракету
var min_distance: float = 50.0  # Минимальное расстояние между звездами
@onready var UB_threshhold = kvadrat.max_height / 2
# Заранее заданные координаты для линий
var line_x_positions: Array = [-600,-500, -400, -200, 200, 400, 500, 600]
# Заранее заданные координаты для змей (по бокам)
var snake_x_positions: Array = [-550,-400, 400, 550]

func _ready():
	camera = get_parent().get_node("Camera2D")

func _physics_process(delta):
	# 1. Получаем размер видимой области
	var viewport = get_viewport()
	if not viewport:
		return
		
	var viewport_rect = viewport.get_visible_rect()
	var visible_height = viewport_rect.size.y / camera.zoom.y
	var visible_width = viewport_rect.size.x / camera.zoom.x
	
	# 2. Определяем зону спавна (2.5 высоты экрана)
	var spawn_zone = visible_height * 2.5
	
	# 3. Проверка для спавна
	if camera.global_position.y <= last_spawned_y + spawn_zone:
		# Определяем тип объектов для спавна
		if camera.global_position.y > -UB_threshhold:
			spawn_random_UB_scene()
		elif camera.global_position.y > -kvadrat.max_height:
			spawn_random_budget_scene()
		else:
			spawn_random_good_scene()
		
		# Обновляем позицию спавна с учетом зума камеры
		last_spawned_y -= visible_height * 0.8  # Спавн с небольшим перекрытием
	
	# 4. Удаление объектов
	remove_far_objects()  # Удаляем на расстоянии 3 высот экрана
func spawn_random_UB_scene():
	var random_choice = randi() % 3
	match random_choice:
		0:
			spawn_UB1()
		1:
			spawn_UB2()
		2:
			spawn_UB3()

func spawn_random_good_scene():
	var random_choice = randi() % 3
	match random_choice:
		0:
			spawn_snakes()  # Спавн одной змейки
		1:
			spawn_we_are_rich(3)  # Спавн 3 экземпляров
		2:
			spawn_two_lines()  # Спавн линий

func spawn_random_budget_scene():
	var random_choice = randi() % 10
	match random_choice:
		0, 1, 2:
			spawn_budget_snakes()  # Спавн двух бюджетных змей
		3, 4, 5:
			spawn_we_are_poor(1)  # Спавн 3 экземпляров
		6:  
			spawn_up_arrow()
		7, 8, 9:
			spawn_crosses()

func spawn_UB1():
	var last_y_position = last_spawned_y
	var spawn_position = Vector2(camera.position.x, last_y_position)
	if true:
		var instance = UB1.instantiate()
		instance.global_position = spawn_position
		add_child(instance)
		last_y_position -= 100

func spawn_UB2():
	var last_y_position = last_spawned_y
	var spawn_position = Vector2(camera.position.x, last_y_position)
	if true:
		var instance = UB2.instantiate()
		instance.global_position = spawn_position
		add_child(instance)
		last_y_position -= 100

func spawn_UB3():
	var last_y_position = last_spawned_y
	var spawn_position = Vector2(camera.position.x, last_y_position)
	if true:
		var instance = UB3.instantiate()
		instance.global_position = spawn_position
		add_child(instance)
		last_y_position -= 100


func spawn_snakes():
	var last_y_position = last_spawned_y
	var spawn_position = Vector2(camera.position.x, last_y_position)
	if true:
		var instance = snakes_scene.instantiate()
		instance.global_position = spawn_position
		add_child(instance)
		last_y_position -= 100

func spawn_we_are_rich(count: int):
	var last_y_position = last_spawned_y  # Сохраняем последнюю позицию Y
	for i in range(count):
		var spawn_position = Vector2(camera.position.x, last_y_position)
		if true:
			var instance = we_are_rich_scene.instantiate()  # Инстанцируем сцену
			instance.global_position = spawn_position
			add_child(instance)
			last_y_position -= 100  # Увеличиваем Y для следующего спавна

func spawn_two_lines():
	for x_position in line_x_positions:
		for offset in [0, 100]:  # Спавн двух линий в высоту
			var spawn_position = Vector2(x_position, last_spawned_y)
			if true:
				var instance = two_lines_scene.instantiate()  # Инстанцируем сцену
				instance.global_position = spawn_position
				add_child(instance)

func spawn_budget_snakes():
	var last_y_position = last_spawned_y
	var spawn_position = Vector2(camera.position.x, last_y_position)
	if true:
		var instance = budget_snakes.instantiate()
		instance.global_position = spawn_position
		add_child(instance)
		last_y_position -= 100

func spawn_we_are_poor(count: int):
	var last_y_position = last_spawned_y  # Сохраняем последнюю позицию Y
	for i in range(count):
		var spawn_position = Vector2(camera.position.x, last_y_position)
		if true:
			var instance = we_are_poor.instantiate()  # Инстанцируем бюджетную сцену
			instance.global_position = spawn_position
			add_child(instance)
			last_y_position -= 100  # Увеличиваем Y для следующего спавна

func spawn_up_arrow():
	var last_y_position = last_spawned_y
	var spawn_position = Vector2(camera.position.x, last_y_position)
	if true:
		var instance = up_arrow.instantiate()
		instance.global_position = spawn_position
		add_child(instance)
		last_y_position -= 100

func spawn_crosses():
	var last_y_position = last_spawned_y
	var spawn_position = Vector2(camera.position.x, last_y_position)
	if true:
		var instance = crosses.instantiate()
		instance.global_position = spawn_position
		add_child(instance)
		last_y_position -= 100
		
func remove_far_objects():
	for child in get_children():
		if child.global_position.y > camera.global_position.y + 5000:
			child.queue_free()  # Удаляем объект
