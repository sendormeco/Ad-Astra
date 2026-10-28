extends Node2D

@export var background_speed_multiplier: float = 0.5  # Множитель для скорости фона
var background: Sprite2D
var rocket: CharacterBody2D  # Ссылка на ракету
var background_height: float  # Высота фона

func _ready():
	background = $deep_space  # Путь к фону
	rocket = $space_ship  # Путь к ракете
	background_height = background.texture.get_size().y  # Получаем высоту фона

func _process(delta):
	# Получаем скорость ракеты
	var rocket_velocity = rocket.velocity.length()

	# Двигаем фон в зависимости от скорости ракеты
	background.position.y += (rocket_velocity * background_speed_multiplier) * delta

	# Проверяем, выходит ли фон за пределы экрана
	if background.position.y > get_viewport().size.y:
		background.position.y -= background_height  # Перемещаем фон обратно

	# Обработка верхней границы (если нужно)
	if background.position.y < -background_height:
		background.position.y += background_height  # Перемещаем фон вверх
