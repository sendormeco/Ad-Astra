extends Sprite2D

@export var speed: float = 100.0
@export var rain_chance: float = 0.1
@export var lightning_interval: float = 1.0  # Интервал между ударами молнии
@onready var camera: Camera2D = get_node('/root/Game/Camera2D')
@onready var min_rain_position = -100000

var direction: float
var is_rain_cloud: bool = false
var has_lightning: bool = false
var lightning_timer: float = 0.0

# Цвета для облаков
var rain_colors = [
	Color(0.5, 0.5, 0.6, 0.9),
	Color(0.45, 0.45, 0.55, 0.9),
	Color(0.6, 0.6, 0.7, 0.85)
]

# Настройки анимации
@export var transition_time: float = 1.5
@export var rain_scale_factor: Vector2 = Vector2(1.25, 1.17)

func _ready():
	direction = randf_range(-1, 1)
	modulate = Color(1, 1, 1, randf_range(0.85, 1.0))
	
	# Проверяем наличие молнии в сцене
	has_lightning = has_node("Lightning")
	if has_lightning:
		$Lightning.visible = false
		$Lightning.monitoring = false
	
	if randf() < rain_chance and global_position.y < min_rain_position:
		make_rain_cloud()

func make_rain_cloud():
	is_rain_cloud = true
	var selected_color = rain_colors[randi() % rain_colors.size()]
	
	# Плавный переход цвета
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate", selected_color, transition_time)
	
	# Лёгкая анимация формы
	var scale_tween = create_tween().set_trans(Tween.TRANS_BACK)
	scale_tween.tween_property(self, "scale", rain_scale_factor, transition_time * 0.8)
	
	# Активируем молнию, если она есть
	if has_lightning:
		$Lightning.visible = true
		$Lightning.monitoring = true
		lightning_timer = randf_range(lightning_interval * 0.5, lightning_interval * 1.5)
	
	# Случайное мерцание
	if randf() > 0.7:
		var flicker_tween = create_tween()
		flicker_tween.tween_property(self, "modulate:v", 1.05, 0.2)
		flicker_tween.tween_property(self, "modulate:v", 0.95, 0.2)
		flicker_tween.set_loops(3)

func _process(delta):
	var effective_speed = speed * (0.9 if is_rain_cloud else 1.0)
	position.x -= effective_speed * delta * direction
	
	# Обработка молнии
	if is_rain_cloud and has_lightning:
		update_lightning(delta)

func update_lightning(delta):
	lightning_timer -= delta
	if lightning_timer <= 0:
		strike_lightning()
		lightning_timer = randf_range(lightning_interval * 0.8, lightning_interval * 1.2)

func strike_lightning():
	if not has_lightning: return
	
	# Анимация удара молнии
	$Lightning.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property($Lightning, "modulate:a", 0.0, 0.5)
	
