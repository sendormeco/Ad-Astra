extends CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in get_particle_count():
		var lifetime_ratio = 1.0 - (get_particle_lifetime(i) / lifetime)
		set_particle_modulate(i, Color(1, 1, 1, lifetime_ratio))
