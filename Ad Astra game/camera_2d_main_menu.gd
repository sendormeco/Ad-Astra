extends Camera2D
@export var zoom_level: float = 1.0  # Базовый зум

func _ready():
	# Делаем камеру текущей
	make_current()
	
	# Настраиваем под размер viewport
	adjust_to_viewport()
func adjust_to_viewport():
	# Получаем размер viewport
	var viewport_size = get_viewport_rect().size
	
	# Рассчитываем зум для заполнения viewport (если нужно)
	var desired_zoom = viewport_size / (get_viewport_rect().size * zoom_level)
	zoom = Vector2(desired_zoom.x, desired_zoom.y)
