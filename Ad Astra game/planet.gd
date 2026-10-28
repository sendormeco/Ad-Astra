extends Sprite2D

@export var min_rotation: float = -180.0
@export var max_rotation: float = 180.0
@export var appear_start_y: float = -5000.0  # Начало появления
@export var appear_end_y: float = -3000.0    # Конец появления
@export var max_alpha: float = 0.1           # Макс. видимость (10%)
@export var camera: Camera2D
@export var scroll_speed: float = 0.5        # Скорость прокрутки (0.5 = 50% от скорости камеры)

var initial_camera_y: float
var initial_planet_y: float

func _ready():
	randomize()
	initial_camera_y = camera.global_position.y
	initial_planet_y = position.y
	apply_random_rotation()
	modulate.a = 0.0

func _process(delta):
	if camera:
		# 1. Управление прозрачностью
		var progress = inverse_lerp(appear_start_y, appear_end_y, camera.global_position.y)
		progress = clamp(progress, 0.0, 1.0)
		modulate.a = max_alpha * smoothstep(0.0, 1.0, progress)
		
		# 2. Плавное движение вниз относительно камеры
		var camera_movement = camera.global_position.y - initial_camera_y
		position.y = initial_planet_y + camera_movement * scroll_speed
		
		# 3. Дополнительный параллакс-эффект (опционально)
		position.x += 10 * sin(Time.get_ticks_msec() * 0.001) * delta  # Легкое покачивание

func apply_random_rotation():
	rotation_degrees = randf_range(min_rotation, max_rotation)
