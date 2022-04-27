extends "res://tanks/Tank.gd"

func _ready():
	$Vision/CollisionShape2D.shape.radius = max_telescope_distance * 2

signal shoot

var target

func _physics_process(delta):
	if target:
		move_telescope(target.global_position, delta)
		var body = telescope.get_collider()
		if body && body == target:
			var bullet = shoot()
			if bullet:
				emit_signal("shoot", bullet)
		else:
			if telescope.rotation > 0.1:
				move_and_slide_body(Vector2(1, 0), delta)
			elif telescope.rotation < -0.1:
				move_and_slide_body(Vector2(-1, 0), delta)
			elif !body:
				move_and_slide_body(Vector2(0, 1), delta)

func _on_Vision_body_entered(body):
	if body.name == "Player":
		target = body

func _on_Vision_body_exited(body):
	if body.name == "Player":
		target = null
