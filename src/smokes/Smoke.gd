extends AnimatedSprite

func _ready():
	frame = 0
	play()

func _on_Smoke_animation_finished():
	queue_free()
