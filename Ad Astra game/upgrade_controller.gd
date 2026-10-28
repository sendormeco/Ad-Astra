extends Node2D

@export var fuel_upgrade_price: int = 1000
@export var magnet_upgrade_price: int = 1500
@export var engine_upgrade_price: int = 2000
@export var control_upgrade_price: int = 2500
@export var armor_upgrade_price: int = 3000
@export var rocket: CharacterBody2D
@export var game: Node2D

@onready var stars_collected: int = 0

func _ready():
	load_stars_collected()
	load_upgrade_data()  # Загружаем данные об апгрейдах при старте

func fuel_upgrade_button_pressed():
	if stars_collected >= fuel_upgrade_price:
		stars_collected -= fuel_upgrade_price
		rocket.max_fuel += 10
		fuel_upgrade_price *= 3
		save_upgrade_data()

func magnet_upgrade_button_pressed():
	# Реализуйте логику для магнитного апгрейда
	pass

func engine_upgrade_button_pressed():
	# Реализуйте логику для апгрейда двигателя
	pass

func control_upgrade_button_pressed():
	# Реализуйте логику для апгрейда управления
	pass

func armor_upgrade_button_pressed():
	# Реализуйте логику для броневого апгрейда
	pass

func save_upgrade_data():
	var config = ConfigFile.new()
	config.set_value("Upgrades", "stars_collected", stars_collected)
	config.save("user://upgrades.cfg")

func load_upgrade_data():
	var config = ConfigFile.new()
	if config.load("user://upgrades.cfg") == OK:
		stars_collected = config.get_value("Upgrades", "stars_collected", 0)
	else:
		print("Не удалось загрузить данные апгрейдов. Устанавливаем в 0.")
		stars_collected = 0

func save_stars_collected():
	var config = ConfigFile.new()
	config.set_value("Stars", "collected", stars_collected)
	config.save(STARS_FILE)

func load_stars_collected():
	var config = ConfigFile.new()
	if config.load(STARS_FILE) == OK:
		stars_collected = config.get_value("Stars", "collected", 0)
	else:
		print("Не удалось загрузить количество собранных звёзд. Устанавливаем в 0.")
		stars_collected = 0
