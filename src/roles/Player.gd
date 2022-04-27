extends "res://tanks/Tank.gd"

onready var mouse = $Mouse
onready var keyboard = $Keyboard

signal shoot

func _physics_process(delta):
	if Input.is_action_just_pressed("shoot"):
		var bullet = shoot()
		if bullet:
			emit_signal("shoot", bullet)
	move_telescope(mouse.get_input(), delta)
	move_and_slide_body(keyboard.get_input(), delta)
