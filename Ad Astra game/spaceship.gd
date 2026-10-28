extends CharacterBody2D

@onready var trail_toggle = $"../TrailToggle"
@export var kvadrat: Sprite2D
@export var is_magnet_active: bool = false
@export var magnet_size: int
@export var armor: int = 0
@export var pause_button: Button
@export var sound_button: Button
@onready var thurst = $thurst
@onready var game = $".."
@export var acceleration = 220000.0
@export var max_speed = 7000.0
@export var friction = 0
@export var x_friction = 400
@export var fall_speed: float = 100.0
@export var screen_width: float = 1600
@export var extra_acceleration = 120000.0
@export var spark_scene: PackedScene
var sprite_timer: Timer
@export var max_fuel: int = 10
@export var fuel: int
@export var fuel_regen_amount: int = 0
@export var fuel_regen_time: float = 5
@export var camera: Camera2D
@export var ship_sprite: Sprite2D
@export var ship_sprite2: Sprite2D
@export var ship_sprite3: Sprite2D
@export var ship_sprite4: Sprite2D
@export var ship_sprite5: Sprite2D
@export var ship_sprite6: Sprite2D
@export var white_screen: ColorRect
@export var flash_duration: float = 0.5 
@export var gravity: Vector2 = Vector2(0, 1300)  # Установите значение гравитации
@export var click_threshold: float = 100.0
@export var control_multiplier: float
@onready var fuel_regen_timer: Timer = Timer.new()
@export var magnet_area: Area2D
@export var magnet_collision: CollisionShape2D
@onready var Trace = $Trace

var control_friction = 1
var flash_active: bool = false
var base_rotation_speed: float = 10.0  # Скорость вращения ракеты
var initial_rotation_direction: float = 0.0
var ready_boom = false
var spawn_timer: float = 0.0
@export var mega_boom_unready: float = 1
var click_count: int = 0 
var facing_direction: int = 1  # 1 - вправо, -1 - влево
@onready var lil_thurst = $lil_thurst
var current_acceleration_multiplier: float = 1.0
var is_active: bool = true
var is_dead: bool = false
@onready var eye = $Eye

func _ready():
	if randi() % 100 == 0:
		eye.visible = true
	update_screen_bounds()
	magnet_area.connect("body_entered", _on_body_entered)
	magnet_area.connect("body_exited", _on_body_exited)
	fuel = max_fuel
	white_screen.visible = false
	sprite_timer = Timer.new()
	sprite_timer.wait_time = 0.2  # Время ожидания в секундах
	sprite_timer.one_shot = true  # Устанавливаем таймер на однократное использование
	sprite_timer.connect("timeout", Callable(self, "_on_sprite_timer_timeout"))  # Подключаем сигнал
	add_child(sprite_timer)  # Добавляем таймер как дочерний узел
	add_to_group("rocket")  # Добавляем ракету в группу
	hide_sprites()  # Скрываем спрайты при запуске
	fuel_regen_timer.wait_time = fuel_regen_time
	fuel_regen_timer.one_shot = false  # Повторяющийся таймер
	fuel_regen_timer.connect("timeout", Callable(self, "_on_fuel_regen_timeout"))  # Подключите сигнал
	add_child(fuel_regen_timer)  # Добавьте таймер как дочерний узел
	fuel_regen_timer.start()  # Запустите таймер
	Trace.emitting = false
	Events.trail_setting_changed.connect(_update_trail)


func is_click_valid(click_position: Vector2) -> bool:
	# 1. Проверяем нажатие на любую TouchScreenButton
	for button in get_tree().get_nodes_in_group("control_buttons"):
		if button is TouchScreenButton and button.is_pressed():
			return false


	# 2. Проверяем зону выше экрана (в координатах вьюпорта)
	return click_position.y < 0

func hide_sprites():
	ship_sprite.visible = false
	ship_sprite2.visible = false
	if ship_sprite3:
		ship_sprite3.visible = false
	if ship_sprite4:
		ship_sprite4.visible = false
	if ship_sprite5:
		ship_sprite5.visible = false

func show_main_engine():
	ship_sprite3.visible = true

func show_sprites():
	ship_sprite.visible = true
	ship_sprite2.visible = true
	if ship_sprite4:
		ship_sprite4.visible = true
	if ship_sprite5:
		ship_sprite5.visible = true

func _process(delta):
	if is_active:
		spawn_timer -= delta
		ready_boom = true
		var direction: Vector2 = Vector2(0, -1).rotated(rotation)
		var angle_to_vertical = direction.angle_to(Vector2(0, -1))
		var camera_node = get_parent().get_node("Camera2D")
		if position.y > camera_node.max_y_position + 3000:
			die()  # Перезагрузка текущей сцены

		if abs(angle_to_vertical) > deg_to_rad(15) and velocity.y >= 0:
			rotation += (velocity.length()) * 0.000005

		if click_count != 0:
			velocity += gravity * delta
		
		if Input.is_action_pressed("left_move") and click_count != 0:
			rotation -= delta * control_multiplier * 10
		
		if Input.is_action_pressed("right_move") and click_count != 0:
			rotation += delta * control_multiplier * 10
		
		if Input.is_action_just_pressed("mouse_click"):
			var mouse_position = get_global_mouse_position()
			if is_click_valid(mouse_position) and fuel >= 1:
				if trail_toggle.button_pressed:
					Trace.emitting = true
				click_count += 1
				fuel -= 1
				print('clicked')
				# Меняем направление вращения на противоположное только если ракета смотрит влево
				if rotation < deg_to_rad(0):
					print(rad_to_deg(rotation))
					base_rotation_speed = -25
				else:
					base_rotation_speed = 25
				if abs(angle_to_vertical) < deg_to_rad(10) and click_count != 0:
					velocity += direction * delta * (acceleration + extra_acceleration * current_acceleration_multiplier)
					current_acceleration_multiplier += 1
					show_main_engine()
					thurst.play()
					if click_count > 1:
						flash_screen()
				elif rotation > deg_to_rad(90) or rotation < deg_to_rad(-90):
					velocity += direction * delta * acceleration * 1.5
					lil_thurst.play()
					current_acceleration_multiplier = 1
				else:
					velocity += direction * delta * acceleration
					lil_thurst.play()
					current_acceleration_multiplier = 1
				
				show_sprites()
				sprite_timer.start()
		rotation *= 0.9995 * control_friction
		if velocity.length() > 0:
			var rotation_speed = base_rotation_speed * (velocity.length() / max_speed)
			rotation += rotation_speed * delta
			rotation = fposmod(rotation, 2 * PI)  # Приводим к диапазону [0, 2*PI]

		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed 

		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		if velocity.x < 0:
			velocity.x += x_friction * delta
		if velocity.x > 0:
			velocity.x -= x_friction * delta

		move_and_slide()

		# Проверка на выход ракеты за границы экрана
		if position.x < -screen_width:
			position.x = screen_width  # Переместить на правую сторону экрана
		elif position.x > screen_width:
			position.x = -screen_width  # Переместить на левую сторону экрана
		if global_position.y < -kvadrat.max_height:
			Trace.emitting = false

func _spawn_sparks():
	if spark_scene:
		var spark_instance = spark_scene.instantiate()  # Создаём экземпляр искры
		get_parent().add_child(spark_instance)  # Добавляем искру в сцену
		
func _on_sprite_timer_timeout():
	hide_sprites()  # Скрываем спрайты по истечении врем

func flash_screen():
	flash_active = true  # Устанавливаем состояние на "активно"
	white_screen.visible = true
	white_screen.modulate.a = 0.0  # Начинаем с прозрачности 0

	# Плавное увеличение прозрачности
	white_screen.modulate.a = 1

	# Плавное уменьшение прозрачности
	var timer: Timer = Timer.new()
	timer.wait_time = flash_duration / 15
	timer.one_shot = true
	add_child(timer)

	for i in range(20, -1, -1):
		white_screen.modulate.a = i * 0.05  # Уменьшаем прозрачность до 0
		timer.start()  # Запускаем таймер
		await timer.timeout  # Ждем истечения таймера

	white_screen.visible = false  # Скрываем после завершения
	flash_active = false  # Сбрасываем состояние

func _on_fuel_regen_timeout():
	if fuel < max_fuel:
		fuel += fuel_regen_amount
		if fuel > max_fuel:
			fuel = max_fuel

func move_star_towards_rocket(star, delta):
	var direction = (position - star.position).normalized()  # Направление к ракете
	star.position += direction * 500 * delta  # Двигаем звезду к ракете

func _on_body_entered(body):
	if body.is_in_group("stars"):
		body.magneted = true  # Перемещение звезды к ракете

func _on_body_exited(body):
	if body.is_in_group("stars"):
		body.magneted = false  # Остановить движение звезды, если вышла за пределы


func die():
	# 1. Отключаем управление и физику
	set_process(false)
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = true
	
	self.visible = false
	# 2. Эффект смерти (красная вспышка)
	white_screen.color = Color(1, 0, 0)
	white_screen.modulate.a = 1.0
	white_screen.visible = true
	
	var tween = create_tween()
	tween.tween_property(white_screen, "modulate:a", 0.0, flash_duration)
	await tween.finished
	
	# 4. Завершение
	white_screen.color = Color(0, 0, 0)
	white_screen.modulate.a = 0.7
	white_screen.visible = true
	
	if game.has_method("rocked_died"):
		game.rocked_died()
	else:
		get_tree().reload_current_scene()  # Фолбэк если метод не найден

func _on_area_2d_area_entered(area):
	if is_magnet_active and area.get_parent().is_in_group('stars'):
		area.get_parent().magneted = true


func _on_area_2d_area_exited(area):
	if area.get_parent().is_in_group('stars'):
		area.get_parent().magneted = false

func update_screen_bounds():
	var viewport_rect = get_viewport_rect()
	screen_width = viewport_rect.size.x * 1.4

func _update_trail(enabled: bool):
	Trace.emitting = enabled
