extends Button

@onready var main = get_node("/root/Game")

func _on_pressed():
	Engine.time_scale = 1
	main.on_exit_button()
	
