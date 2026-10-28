extends Node2D

@export var speed: float = 200.0

func _process(delta: float) -> void:
	# Обновляем позицию птицы
	position.x += speed * delta
	
	# Если птица выходит за пределы экрана, сбрасываем позицию
	if position.x > get_viewport().size.x:
		position.x = -position.x
