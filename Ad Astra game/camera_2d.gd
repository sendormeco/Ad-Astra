extends Camera2D

@export var rocket: CharacterBody2D  # Ссылка на ракету
@export var otstup: float = 1100  # Смещение по Y от ракеты
@export var max_y_position: float  # Максимальная позиция Y камеры
var camera_speed: float = 12.0  # Скорость движения камеры
var camera_active: bool = false  # Переменная для отслеживания состояния камеры

func _ready():
	rocket = get_parent().get_node("space_ship")
	position.y = rocket.position.y + 100  # Устанавливаем позицию камеры на уровень ракеты
	max_y_position = position.y  # Изначально устанавливаем максимальную позици

func _input(event):
	if  Input.is_action_just_pressed('mouse_click'):
		camera_active = true  # Активируем движение камеры при первом щелчке мыши

func _process(delta):
	camera_speed = abs(rocket.velocity.y / 200 - 2) + 1
	if camera_active:
		# Проверяем, поднимается ли ракета и приближается ли к верхней границе
		if rocket.velocity.y < 0 and rocket.position.y < position.y + 700:
			# Устанавливаем новую позицию камеры
			var target_camera_position_y = rocket.position.y - otstup
			var distance = target_camera_position_y - position.y

			# Двигаем камеру обратно пропорционально расстоянию
			if distance != 0:
				position.y += distance * 0.26 * camera_speed * delta  # Измените 0.1 для настройки скорости

			# Обновляем максимальную позицию, если новая позиция выше
			if position.y < max_y_position:
				max_y_position = position.y

		# Убедитесь, что камера не опускается ниже максимальной позиции
		if position.y > max_y_position:
			position.y = max_y_position
