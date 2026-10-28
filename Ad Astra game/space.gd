extends Node2D

@export var rocket: CharacterBody2D

func _process(delta):
	# Если ракета выше заданного порога, двигаем фон
	if rocket.position.y >= position.y:
		position.y = rocket.position.y
