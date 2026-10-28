extends Node2D
@onready var star_pickup = $star_pickup
@onready var game = get_node("/root/Game")
@onready var rocket = get_node('/root/Game/space_ship')
@onready var star_controller = get_node("/root/Game/star_controller")
var magneted = false

func _ready():
	add_to_group("stars")
	star_controller.add_child(self)
	var area = $Area2D  # Получаем узел Area2D
	area.connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("rocket"):
		play_effect()
		star_pickup.play()
		$Sprite2D.visible = false
		game.picked_up_star()

func _physics_process(delta):
	if magneted == true:
		move_towards_rocket(delta)

func move_towards_rocket(delta):
	var direction = (rocket.global_position - global_position).normalized()
	position += direction * 800 * delta  # Двигаем звезду к ракете


func play_effect():
	var particles = $GPUParticles2D  # Убедитесь, что путь правильный
	if particles:
		particles.emitting = true  # Запускаем эмиссию частиц
