extends Camera2D

export (float) var zoom_speed = 0.1
var zoom_ratio = 1 setget set_zoom_ratio
var min_zoom_ratio = 1
var max_zoom_ratio = 5

func set_zoom_ratio(ratio):
	zoom_ratio = clamp(ratio, min_zoom_ratio, max_zoom_ratio)
	zoom = Vector2(zoom_ratio, zoom_ratio)

func _process(delta):
	if Input.is_action_pressed("switch_camera"):
		position = to_local(get_global_mouse_position())
	elif Input.is_action_just_released("switch_camera"):
		position = Vector2.ZERO
	if Input.is_action_just_released("zoom_in"):
		set_zoom_ratio(zoom_ratio-zoom_speed)
	if Input.is_action_just_released("zoom_out"):
		set_zoom_ratio(zoom_ratio+zoom_speed)
