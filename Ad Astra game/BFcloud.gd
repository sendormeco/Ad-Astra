extends Sprite2D

@export var speed: float = 25.0
@export var range: int = 150  # Половина от 1500 пикселей
var direction: int = 1
var initial_position: float
var x_travelled: float = 0

func _ready():
	initial_position = position.x  # Сохраняем начальную позицию

func _process(delta):
	x_travelled += speed * delta
	position.x += speed * direction * delta

	# Проверяем, если облако прошло заданный радиус
	if abs(x_travelled) >= range:
		direction *= -1  # Меняем направление
		x_travelled = 0  # Сбрасываем расстояние, чтобы отслеживать его заново
