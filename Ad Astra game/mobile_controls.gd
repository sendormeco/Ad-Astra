extends Control

@export var camera: Camera2D

@onready var left_button = $LeftButton
@onready var right_button = $RightButton

var left_pressed := false
var right_pressed := false

func _ready():
	left_button.pressed.connect(_on_left_pressed)
	left_button.released.connect(_on_left_released)
	right_button.pressed.connect(_on_right_pressed)
	right_button.released.connect(_on_right_released)
	
	# Только для мобильных устройств
	
	


func _on_left_pressed():
	left_pressed = true
	Input.action_press("left_move")  # Или ваш кастомный action

func _on_left_released():
	left_pressed = false
	Input.action_release("left_move")

func _on_right_pressed():
	right_pressed = true
	Input.action_press("right_move")

func _on_right_released():
	right_pressed = false
	Input.action_release("right_move")

func _input(event):
	# Для отладки на ПК - имитируем касания клавишами
	if not OS.has_feature("mobile"):
		if event.is_action_pressed("left_move"):
			_on_left_pressed()
		elif event.is_action_released("left_move"):
			_on_left_released()
		# Аналогично для правой кнопки
