extends Button

@onready var main = get_node("/root/Game")

func _on_pressed():
	main.pauseMenu()
