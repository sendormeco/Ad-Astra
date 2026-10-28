extends Sprite2D

@export var kvadrat: Sprite2D
@export var rocket: CharacterBody2D
@export var moon_sprites: Array[Texture]  # Массив для хранения текстур луны
var speed: float = 0
var target_height: float  # Высота, при достижении которой луна начнет появляться
var max_alpha: float = 1.0  # Максимальная прозрачность луны

func _ready():
	target_height = kvadrat.max_height * 0.2
	modulate.a = 0.0  # Изначально луна скрыта
	choose_random_moon_sprite()  # Выбор случайного спрайта

func choose_random_moon_sprite():
	# Выбор случайного спрайта из массива
	var random_index = randi() % moon_sprites.size()
	texture = moon_sprites[random_index]  # Установка текстуры луны

func _process(delta):
	speed = -rocket.velocity.y / 200
	position.y += speed * delta / 4
	if rocket.position.y > -kvadrat.max_height + 5000:
		modulate.a = abs(rocket.position.y / kvadrat.max_height)
	elif rocket.position.y < -kvadrat.max_height + 5000:
		if modulate.a > 0.05:
			modulate.a = abs((-kvadrat.max_height / (rocket.position.y)) / (1 + (abs(rocket.position.y + kvadrat.max_height - 5000) / 1000)))
		elif  modulate.a < 0.05:
			visible = false
