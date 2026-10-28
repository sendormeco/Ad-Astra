extends Sprite2D

@export var max_height: float = 1
@export var gradient: Gradient
@export var start_height: float
var is_gradient_visible: bool = false
var camera: Camera2D

func _ready():
	# Ждем первый кадр для корректного получения размеров
	await get_tree().process_frame
	
	# Получаем камеру автоматически
	camera = get_viewport().get_camera_2d()
	if not camera:
		push_error("Camera2D not found!")
		return
	
	# Первоначальная настройка размера
	_update_size()
	
	# Подключаем сигнал изменения размера
	get_viewport().connect("size_changed", _update_size)

func _process(delta):
	if not is_instance_valid(camera):
		return
	
	# Градиентная логика (ваш оригинальный код)
	if position.y > start_height:
		return

	var rocket = get_parent().get_node("space_ship")
	is_gradient_visible = rocket.position.y < start_height

	if is_gradient_visible:
		var normalized_position = (-rocket.position.y) / max_height
		normalized_position = clamp(normalized_position, 0.0, 1.0)
		self_modulate = gradient.sample(normalized_position)

func _update_size():
	if not is_instance_valid(camera):
		return
	
	# Получаем реальные размеры видимой области с учетом зума камеры
	var viewport_size = get_viewport().get_visible_rect().size
	var visible_size = Vector2(
		viewport_size.x / camera.zoom.x,
		viewport_size.y * 2 / camera.zoom.y
	)
	
	# Рассчитываем масштаб для полного покрытия
	var texture_size = texture.get_size()
	if texture_size.x > 0 and texture_size.y > 0:  # Защита от деления на 0
		var scale_x = visible_size.x + 50 / texture_size.x
		var scale_y = visible_size.y / texture_size.y
		
		# Берем максимальный масштаб для полного покрытия
		scale = Vector2(scale_x, scale_y)
		
		# Центрируем спрайт
		position = camera.get_screen_center_position()
	
	# Для отладки
	print("Updated size: ", scale, " | Visible size: ", visible_size)
