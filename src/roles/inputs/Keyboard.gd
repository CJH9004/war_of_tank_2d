extends Object

func get_input():
	return Vector2(
		Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_up")-Input.get_action_strength("ui_down"))
