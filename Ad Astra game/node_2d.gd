extends Area2D

@export var speed: float = 0
@export var possible_sprites: Array[Texture2D] = []

func _ready():
	connect("body_entered", Callable(self, '_on_body_entered'))
	if possible_sprites.size() > 0:
		$Sprite2D.texture = possible_sprites[randi() % possible_sprites.size()]
	
	# Настройка коллайдера под размер спрайта
	var sprite_size = $Sprite2D.get_rect().size
	$CollisionShape2D.shape = RectangleShape2D.new()
	$CollisionShape2D.shape.size = sprite_size

func _process(delta):
	position.x -= speed * delta
	if position.x < -100:
		queue_free()
		
func _on_body_entered(body):
	if body.is_in_group("rocket"):
		if body.armor > 1:
			hide()
			body.armor -= 1
		else:
			body.velocity = Vector2(0, 0)
			body.die()
