extends CanvasLayer

@onready var fade_rect = $ColorRect
@export var fade_duration: float = 0.5

func _ready():
	fade_rect.color = Color.BLACK
	fade_rect.color.a = 0.0  # Начинаем с прозрачного

func transition_to(scene_path: String):
	# Затемнение перед переходом
	var fade_out = create_tween()
	fade_out.tween_property(fade_rect, "color:a", 1.0, fade_duration)
	fade_out.tween_callback(func():
		_change_scene(scene_path)
	)

func _change_scene(scene_path: String):
	# Меняем сцену
	if get_tree().change_scene_to_file(scene_path) != OK:
		push_error("Failed to load scene: ", scene_path)
	
	# Появление после загрузки
	var fade_in = create_tween()
	fade_in.tween_property(fade_rect, "color:a", 0.0, fade_duration)
