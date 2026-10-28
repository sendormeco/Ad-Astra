extends CanvasLayer

# Настройки кнопок
@export var button_size := Vector2(150, 150)
@export var button_margin := 50

func _ready():
	_setup_controls()

func _setup_controls():
	# Левая кнопка
	var left_button = TouchScreenButton.new()
	left_button.texture_normal = load("res://arrow_basic_w.png")
	left_button.action = "left_move"  # Должно совпадать с Input Map!
	left_button.position = Vector2(button_margin, get_viewport().size.y - button_size.y - button_margin)
	add_child(left_button)
	
	# Правая кнопка
	var right_button = TouchScreenButton.new()
	right_button.texture_normal = load("res://arrow_basic_e.png")
	right_button.action = "right_move"
	right_button.position = Vector2(button_margin*2 + button_size.x, get_viewport().size.y - button_size.y - button_margin)
	add_child(right_button)

	# Растягиваем зоны нажатия
	left_button.shape = RectangleShape2D.new()
	left_button.shape.extents = button_size/2
	right_button.shape = RectangleShape2D.new()
	right_button.shape.extents = button_size/2
