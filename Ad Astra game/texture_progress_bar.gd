extends TextureProgressBar

@export var right_margin: float = 50.0  # Отступ от правого края
@export var top_margin: float = 20.0    # Отступ от верхнего края
var camera: Camera2D

func _ready():
	# Ждем кадр для корректного определения камеры
	await get_tree().process_frame
	camera = get_viewport().get_camera_2d()
	
	if camera:
		position_element()
		# Подключаемся к сигналу изменения viewport
		get_viewport().connect("size_changed", position_element)
	else:
		push_error("Camera2D not found in viewport")

func position_element():
	if !is_instance_valid(camera):
		return
	
	# Получаем текущий viewport
	var viewport = get_viewport().get_visible_rect()
	var zoom = camera.zoom
	
	# Рассчитываем позицию относительно камеры
	var camera_right_edge = camera.global_position.x + (viewport.size.x * 0.5 / zoom.x)
	var camera_top_edge = camera.global_position.y - (viewport.size.y * 0.5 / zoom.y)
	
	# Устанавливаем позицию ProgressBar
	global_position = Vector2(
		camera_right_edge - right_margin - (size.x * scale.x),
		camera_top_edge + top_margin
	)

func _notification(what):
	# Корректно обрабатываем изменение размера окна
	if what == NOTIFICATION_WM_SIZE_CHANGED:
		position_element()
