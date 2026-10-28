extends Area2D

signal collected  # Сигнал для сбора звезды

func _ready():
	add_to_group("stars")
	Area2D.body_entered.connect(_on_area_2d_body_entered)
func _on_area_2d_body_entered(body):
	queue_free()
