extends Button

@export var camera: Camera2D
@export var main = Node2D

func _on_pressed():
	main.pauseMenu()
	print('paused!')
