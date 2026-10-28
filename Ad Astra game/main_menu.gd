extends CanvasLayer

@onready var title_label = $Label
func _ready():
	# Получаем ссылку на кнопку
	start_title_pulse()


func start_title_pulse():
	var tween = create_tween().set_loops().set_parallel(false)
	
	# Пульсация: увеличение и уменьшение масштаба
	tween.tween_property(title_label, "scale", Vector2(1.1, 1.1), 3.0)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(title_label, "scale", Vector2(1.0, 1.0), 3.0)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	# Дополнительно: пульсация прозрачности
	var color_tween = create_tween().set_loops()
	color_tween.tween_property(title_label, "modulate:a", 0.8, 1.0)
	color_tween.tween_property(title_label, "modulate:a", 1.0, 1.0)
	
