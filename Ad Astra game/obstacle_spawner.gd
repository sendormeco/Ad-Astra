extends Node2D

@export var obstacle_scenes: Array[PackedScene]
@export var camera: Camera2D
@export var min_spawn_distance: float = 1000.0  # Минимальное расстояние от нижнего края
@export var x_margin: float = 100.0  # Отступ от краев экрана

var next_spawn_y: float = -10000.0
var rng = RandomNumberGenerator.new()
var viewport_size: Vector2 = Vector2.ZERO

func _ready():
	rng.randomize()
	if not camera:
		camera = get_viewport().get_camera_2d()
	viewport_size = get_viewport().get_visible_rect().size
	next_spawn_y = calculate_spawn_position()

func _physics_process(_delta):
	var camera_top_y = camera.global_position.y - viewport_size.y/2
	
	if camera_top_y <= next_spawn_y:
		spawn_obstacle()
		next_spawn_y = calculate_spawn_position()
		
	cleanup_obstacles(camera.global_position.y + 10000.0)

func calculate_spawn_position() -> float:
	var camera_top = camera.global_position.y - viewport_size.y/2
	return camera_top - min_spawn_distance - rng.randf_range(0, 500)

func calculate_x_range() -> Vector2:
	# Рассчитываем диапазон по X на основе ширины экрана с отступами
	var screen_width = viewport_size.x
	return Vector2(
		-screen_width/2 + x_margin,  # Левый край
		screen_width/2 - x_margin     # Правый край
	)

func spawn_obstacle():
	if obstacle_scenes.is_empty():
		return
	
	var obstacle = obstacle_scenes[rng.randi() % obstacle_scenes.size()].instantiate()
	var x_range = calculate_x_range()
	var x_pos = rng.randf_range(x_range.x, x_range.y)
	obstacle.global_position = Vector2(x_pos, next_spawn_y)
	add_child(obstacle)
	
	print("Спавн на позиции: ", Vector2(x_pos, next_spawn_y),
		  " | Диапазон X: ", x_range)

func cleanup_obstacles(threshold: float):
	for child in get_children():
		if child.global_position.y > threshold:
			child.queue_free()
