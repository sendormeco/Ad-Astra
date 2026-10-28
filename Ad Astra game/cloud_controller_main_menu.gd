extends Node2D

@export var cloud_scenes: Array[PackedScene]  # Все ваши 8 сцен облаков
@export var spawn_margin: float = 1000.0       # Отступ для спавна за границей экрана
@export var min_speed: float = 30.0          # Минимальная скорость облака
@export var max_speed: float = 80.0          # Максимальная скорость облака
@export var max_clouds: int = 8              # Максимальное число облаков

var camera: Camera2D
var active_clouds: Array = []

func _ready():
	# Получаем камеру (должна быть в дереве сцены)
	camera = get_viewport().get_camera_2d()
	
	# Таймер для спавна
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 2.0  # Интервал спавна
	timer.timeout.connect(_spawn_cloud_group)
	timer.start()
	
	# Сразу создаем первую группу облаков
	_spawn_cloud_group()

func _spawn_cloud_group():
	if active_clouds.size() >= max_clouds:
		return
	
	# Случайное количество облаков в группе (1-3)
	var cloud_count = randi() % 3 + 1
	
	for i in range(cloud_count):
		_spawn_single_cloud()

func _spawn_single_cloud():
	var cloud_scene = cloud_scenes[randi() % cloud_scenes.size()]
	var cloud = cloud_scene.instantiate()
	
	# Настройка параметров облака
	var speed = randf_range(min_speed, max_speed)
	cloud.set_meta("speed", speed)
	
	# Случайный масштаб и прозрачность
	var scale = randf_range(0.5, 1.2)
	cloud.scale = Vector2(scale, scale)
	cloud.modulate.a = randf_range(0.4, 0.8)
	
	# Позиция спавна (левая или правая граница)
	var spawn_side = randi() % 2  # 0 - слева, 1 - справа
	var camera_rect = _get_camera_rect()
	
	if spawn_side == 0:
		cloud.position.x = camera_rect.position.x - spawn_margin
	else:
		cloud.position.x = camera_rect.end.x + spawn_margin
	
	# Случайная высота в пределах видимой области
	cloud.position.y = randf_range(
		camera_rect.position.y - 200,
		camera_rect.end.y + 200
	)
	
	add_child(cloud)
	active_clouds.append(cloud)

func _process(delta):
	var camera_rect = _get_camera_rect()
	
	for cloud in active_clouds.duplicate():
		var speed = cloud.get_meta("speed")
		cloud.position.x += speed * delta * (1 if speed > 0 else -1)
		
		# Новое условие удаления - только когда облако полностью за spawn_margin
		if (cloud.position.x > camera_rect.end.x + 2 * spawn_margin or 
			cloud.position.x < camera_rect.position.x - 2 * spawn_margin):
			
			cloud.queue_free()
			active_clouds.erase(cloud)


# Возвращает текущий прямоугольник видимости камеры
func _get_camera_rect() -> Rect2:
	if !camera:
		return Rect2()
	
	var camera_pos = camera.global_position
	var viewport_size = get_viewport().size
	return Rect2(
		camera_pos - viewport_size * 0.5,
		viewport_size
	)
